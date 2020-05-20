package main

// Package curve25519sign implements a signature scheme based on Curve25519 keys.
// See https://moderncrypto.org/mail-archive/curves/2014/000205.html for details.

import "C"

import (
	"crypto/rand"
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"io"

	"github.com/agl/ed25519"
	"github.com/agl/ed25519/edwards25519"
)

//export SignSignature
func SignSignature(privateKey, message, dest *string) {
	private, err := hex.DecodeString(*privateKey)
	if err != nil {
		fmt.Println(err)
		return
	}
	var p [32]byte
	copy(p[:], private[:])

	msg, err := hex.DecodeString(*message)
	if err != nil {
		fmt.Println(err)
		return
	}
	var random [64]byte
	r := rand.Reader
	io.ReadFull(r, random[:])

	d := *Sign(&p, msg, random)
	*dest = hex.EncodeToString(d[:])
	fmt.Println(dest)
}

//export VerifySignature
func VerifySignature(publicKey, message, signature *string) bool {
	public, err := hex.DecodeString(*publicKey)
	if err != nil {
		fmt.Println(err)
		return false
	}
	var p [32]byte
	copy(p[:], public[:])

	msg, err := hex.DecodeString(*message)
	if err != nil {
		fmt.Println(err)
		return false
	}

	sig, err := hex.DecodeString(*signature)
	if err != nil {
		fmt.Println(err)
		return false
	}
	var s [64]byte
	copy(s[:], sig[:])
	return Verify(p, msg, &s)
}

// sign signs the message with privateKey and returns a signature as a byte slice.
func Sign(privateKey *[32]byte, message []byte, random [64]byte) *[64]byte {

	// Calculate Ed25519 public key from Curve25519 private key
	var A edwards25519.ExtendedGroupElement
	var publicKey [32]byte
	edwards25519.GeScalarMultBase(&A, privateKey)
	A.ToBytes(&publicKey)

	// Calculate r
	diversifier := [32]byte{
		0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
		0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
		0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
		0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}

	var r [64]byte
	hash := sha512.New()
	hash.Write(diversifier[:])
	hash.Write(privateKey[:])
	hash.Write(message)
	hash.Write(random[:])
	hash.Sum(r[:0])

	// Calculate R
	var rReduced [32]byte
	edwards25519.ScReduce(&rReduced, &r)
	var R edwards25519.ExtendedGroupElement
	edwards25519.GeScalarMultBase(&R, &rReduced)

	var encodedR [32]byte
	R.ToBytes(&encodedR)

	// Calculate S = r + SHA2-512(R || A_ed || msg) * a  (mod L)
	var hramDigest [64]byte
	hash.Reset()
	hash.Write(encodedR[:])
	hash.Write(publicKey[:])
	hash.Write(message)
	hash.Sum(hramDigest[:0])
	var hramDigestReduced [32]byte
	edwards25519.ScReduce(&hramDigestReduced, &hramDigest)

	var s [32]byte
	edwards25519.ScMulAdd(&s, &hramDigestReduced, privateKey, &rReduced)

	signature := new([64]byte)
	copy(signature[:], encodedR[:])
	copy(signature[32:], s[:])
	signature[63] |= publicKey[31] & 0x80

	return signature
}

// verify checks whether the message has a valid signature.
func Verify(publicKey [32]byte, message []byte, signature *[64]byte) bool {

	publicKey[31] &= 0x7F

	/* Convert the Curve25519 public key into an Ed25519 public key.  In
	particular, convert Curve25519's "montgomery" x-coordinate into an
	Ed25519 "edwards" y-coordinate:

	ed_y = (mont_x - 1) / (mont_x + 1)

	NOTE: mont_x=-1 is converted to ed_y=0 since fe_invert is mod-exp

	Then move the sign bit into the pubkey from the signature.
	*/

	var edY, one, montX, montXMinusOne, montXPlusOne edwards25519.FieldElement
	edwards25519.FeFromBytes(&montX, &publicKey)
	edwards25519.FeOne(&one)
	edwards25519.FeSub(&montXMinusOne, &montX, &one)
	edwards25519.FeAdd(&montXPlusOne, &montX, &one)
	edwards25519.FeInvert(&montXPlusOne, &montXPlusOne)
	edwards25519.FeMul(&edY, &montXMinusOne, &montXPlusOne)

	var A_ed [32]byte
	edwards25519.FeToBytes(&A_ed, &edY)

	A_ed[31] |= signature[63] & 0x80
	signature[63] &= 0x7F

	return ed25519.Verify(&A_ed, message, signature)
}

// Unused
func main() {}

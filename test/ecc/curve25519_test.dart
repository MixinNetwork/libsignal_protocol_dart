import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/invalid_key_exception.dart';
import 'package:test/test.dart';

void main() {
  test('testAgreement', () {
    final alicePublic = Uint8List.fromList([
      0x05,
      0x1b,
      0xb7,
      0x59,
      0x66,
      0xf2,
      0xe9,
      0x3a,
      0x36,
      0x91,
      0xdf,
      0xff,
      0x94,
      0x2b,
      0xb2,
      0xa4,
      0x66,
      0xa1,
      0xc0,
      0x8b,
      0x8d,
      0x78,
      0xca,
      0x3f,
      0x4d,
      0x6d,
      0xf8,
      0xb8,
      0xbf,
      0xa2,
      0xe4,
      0xee,
      0x28
    ]);

    final alicePrivate = Uint8List.fromList([
      0xc8,
      0x06,
      0x43,
      0x9d,
      0xc9,
      0xd2,
      0xc4,
      0x76,
      0xff,
      0xed,
      0x8f,
      0x25,
      0x80,
      0xc0,
      0x88,
      0x8d,
      0x58,
      0xab,
      0x40,
      0x6b,
      0xf7,
      0xae,
      0x36,
      0x98,
      0x87,
      0x90,
      0x21,
      0xb9,
      0x6b,
      0xb4,
      0xbf,
      0x59
    ]);

    final bobPublic = Uint8List.fromList([
      0x05,
      0x65,
      0x36,
      0x14,
      0x99,
      0x3d,
      0x2b,
      0x15,
      0xee,
      0x9e,
      0x5f,
      0xd3,
      0xd8,
      0x6c,
      0xe7,
      0x19,
      0xef,
      0x4e,
      0xc1,
      0xda,
      0xae,
      0x18,
      0x86,
      0xa8,
      0x7b,
      0x3f,
      0x5f,
      0xa9,
      0x56,
      0x5a,
      0x27,
      0xa2,
      0x2f
    ]);

    final bobPrivate = Uint8List.fromList([
      0xb0,
      0x3b,
      0x34,
      0xc3,
      0x3a,
      0x1c,
      0x44,
      0xf2,
      0x25,
      0xb6,
      0x62,
      0xd2,
      0xbf,
      0x48,
      0x59,
      0xb8,
      0x13,
      0x54,
      0x11,
      0xfa,
      0x7b,
      0x03,
      0x86,
      0xd4,
      0x5f,
      0xb7,
      0x5d,
      0xc5,
      0xb9,
      0x1b,
      0x44,
      0x66
    ]);

    final shared = Uint8List.fromList([
      0x32,
      0x5f,
      0x23,
      0x93,
      0x28,
      0x94,
      0x1c,
      0xed,
      0x6e,
      0x67,
      0x3b,
      0x86,
      0xba,
      0x41,
      0x01,
      0x74,
      0x48,
      0xe9,
      0x9b,
      0x64,
      0x9a,
      0x9c,
      0x38,
      0x06,
      0xc1,
      0xdd,
      0x7c,
      0xa4,
      0xc4,
      0x77,
      0xe6,
      0x29
    ]);

    final alicePublicKey = Curve.decodePoint(alicePublic, 0);
    final alicePrivateKey = Curve.decodePrivatePoint(alicePrivate);

    final bobPublicKey = Curve.decodePoint(bobPublic, 0);
    final bobPrivateKey = Curve.decodePrivatePoint(bobPrivate);

    final sharedOne = Curve.calculateAgreement(alicePublicKey, bobPrivateKey);
    final sharedTwo = Curve.calculateAgreement(bobPublicKey, alicePrivateKey);

    expect(sharedOne, shared);
    expect(sharedTwo, shared);
  });

  test('testRandomAgreements', () {
    for (var i = 0; i < 50; i++) {
      final alice = Curve.generateKeyPair();
      final bob = Curve.generateKeyPair();

      final sharedAlice =
          Curve.calculateAgreement(bob.publicKey, alice.privateKey);
      final sharedBob =
          Curve.calculateAgreement(alice.publicKey, bob.privateKey);

      expect(sharedAlice, sharedBob);
    }
  });

  test('testSignature', () {
    final aliceIdentityPrivate = Uint8List.fromList([
      0xc0,
      0x97,
      0x24,
      0x84,
      0x12,
      0xe5,
      0x8b,
      0xf0,
      0x5d,
      0xf4,
      0x87,
      0x96,
      0x82,
      0x05,
      0x13,
      0x27,
      0x94,
      0x17,
      0x8e,
      0x36,
      0x76,
      0x37,
      0xf5,
      0x81,
      0x8f,
      0x81,
      0xe0,
      0xe6,
      0xce,
      0x73,
      0xe8,
      0x65
    ]);

    final aliceIdentityPublic = Uint8List.fromList([
      0x05,
      0xab,
      0x7e,
      0x71,
      0x7d,
      0x4a,
      0x16,
      0x3b,
      0x7d,
      0x9a,
      0x1d,
      0x80,
      0x71,
      0xdf,
      0xe9,
      0xdc,
      0xf8,
      0xcd,
      0xcd,
      0x1c,
      0xea,
      0x33,
      0x39,
      0xb6,
      0x35,
      0x6b,
      0xe8,
      0x4d,
      0x88,
      0x7e,
      0x32,
      0x2c,
      0x64
    ]);

    final aliceEphemeralPublic = Uint8List.fromList([
      0x05,
      0xed,
      0xce,
      0x9d,
      0x9c,
      0x41,
      0x5c,
      0xa7,
      0x8c,
      0xb7,
      0x25,
      0x2e,
      0x72,
      0xc2,
      0xc4,
      0xa5,
      0x54,
      0xd3,
      0xeb,
      0x29,
      0x48,
      0x5a,
      0x0e,
      0x1d,
      0x50,
      0x31,
      0x18,
      0xd1,
      0xa8,
      0x2d,
      0x99,
      0xfb,
      0x4a
    ]);

    final aliceSignature = Uint8List.fromList([
      0x5d,
      0xe8,
      0x8c,
      0xa9,
      0xa8,
      0x9b,
      0x4a,
      0x11,
      0x5d,
      0xa7,
      0x91,
      0x09,
      0xc6,
      0x7c,
      0x9c,
      0x74,
      0x64,
      0xa3,
      0xe4,
      0x18,
      0x02,
      0x74,
      0xf1,
      0xcb,
      0x8c,
      0x63,
      0xc2,
      0x98,
      0x4e,
      0x28,
      0x6d,
      0xfb,
      0xed,
      0xe8,
      0x2d,
      0xeb,
      0x9d,
      0xcd,
      0x9f,
      0xae,
      0x0b,
      0xfb,
      0xb8,
      0x21,
      0x56,
      0x9b,
      0x3d,
      0x90,
      0x01,
      0xbd,
      0x81,
      0x30,
      0xcd,
      0x11,
      0xd4,
      0x86,
      0xce,
      0xf0,
      0x47,
      0xbd,
      0x60,
      0xb8,
      0x6e,
      0x88
    ]);

    // ignore: unused_local_variable
    final alicePrivateKey = Curve.decodePrivatePoint(aliceIdentityPrivate);
    final alicePublicKey = Curve.decodePoint(aliceIdentityPublic, 0);
    final aliceEphemeral = Curve.decodePoint(aliceEphemeralPublic, 0);

    if (!Curve.verifySignature(
        alicePublicKey, aliceEphemeral.serialize(), aliceSignature)) {
      throw AssertionError('Sig verification failed!');
    }

    for (var i = 0; i < aliceSignature.length; i++) {
      final modifiedSignature = Uint8List(aliceSignature.length);
      Curve.arraycopy(
          aliceSignature, 0, modifiedSignature, 0, modifiedSignature.length);

      modifiedSignature[i] ^= 0x01;

      if (Curve.verifySignature(
          alicePublicKey, aliceEphemeral.serialize(), modifiedSignature)) {
        throw AssertionError('Sig verification succeeded!');
      }
    }
  });

  test('testDecodeSize', () {
    final keyPair = Curve.generateKeyPair();
    final serializedPublic = keyPair.publicKey.serialize();

    final justRight = Curve.decodePoint(serializedPublic, 0);

    try {
      // ignore: unused_local_variable
      final tooSmall = Curve.decodePoint(serializedPublic, 1);
      throw AssertionError("Shouldn't decode");
    } on InvalidKeyException {
      // good
    }

    try {
      // ignore: unused_local_variable
      final empty = Curve.decodePoint(Uint8List(0), 0);
      throw AssertionError("Shouldn't parse");
    } on InvalidKeyException {
      // good
    }

    try {
      final badKeyType = Uint8List(33);
      Curve.arraycopy(
          serializedPublic, 0, badKeyType, 0, serializedPublic.length);
      badKeyType[0] = 0x01;
      Curve.decodePoint(badKeyType, 0);
      throw AssertionError('Should be bad key type');
    } on InvalidKeyException {
      // good
    }

    final extraSpace = Uint8List(serializedPublic.length + 1);
    Curve.arraycopy(
        serializedPublic, 0, extraSpace, 0, serializedPublic.length);
    final extra = Curve.decodePoint(extraSpace, 0);

    final offsetSpace = Uint8List(serializedPublic.length + 1);
    Curve.arraycopy(
        serializedPublic, 0, offsetSpace, 1, serializedPublic.length);
    final offset = Curve.decodePoint(offsetSpace, 1);

    expect(serializedPublic, justRight.serialize());
    expect(extra.serialize(), serializedPublic);
    expect(offset.serialize(), serializedPublic);
  });
}

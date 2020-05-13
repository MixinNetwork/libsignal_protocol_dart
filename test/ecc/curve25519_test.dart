import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/InvalidKeyException.dart';
import 'package:test/test.dart';

void main() {
  test('testAgreement', () {
    var alicePublic = Uint8List.fromList([
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

    var alicePrivate = Uint8List.fromList([
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

    var bobPublic = Uint8List.fromList([
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

    var bobPrivate = Uint8List.fromList([
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

    var shared = Uint8List.fromList([
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

    var alicePublicKey = Curve.decodePoint(alicePublic, 0);
    var alicePrivateKey = Curve.decodePrivatePoint(alicePrivate);

    var bobPublicKey = Curve.decodePoint(bobPublic, 0);
    var bobPrivateKey = Curve.decodePrivatePoint(bobPrivate);

    var sharedOne = Curve.calculateAgreement(alicePublicKey, bobPrivateKey);
    var sharedTwo = Curve.calculateAgreement(bobPublicKey, alicePrivateKey);

    expect(sharedOne, shared);
    expect(sharedTwo, shared);
  });

  test('testRandomAgreements', () {
    for (int i = 0; i < 50; i++) {
      var alice = Curve.generateKeyPair();
      var bob = Curve.generateKeyPair();

      var sharedAlice =
          Curve.calculateAgreement(bob.publicKey, alice.privateKey);
      var sharedBob = Curve.calculateAgreement(alice.publicKey, bob.privateKey);

      expect(sharedAlice, sharedBob);
    }
  });

  test('testDecodeSize', () {
    var keyPair = Curve.generateKeyPair();
    var serializedPublic = keyPair.publicKey.serialize();

    var justRight = Curve.decodePoint(serializedPublic, 0);

    try {
      var tooSmall = Curve.decodePoint(serializedPublic, 1);
      throw AssertionError("Shouldn't decode");
    } on InvalidKeyException catch (e) {
      // good
    }

    try {
      var empty = Curve.decodePoint(Uint8List(0), 0);
      throw AssertionError("Shouldn't parse");
    } on InvalidKeyException catch (e) {
      // good
    }

    try {
      var badKeyType = Uint8List(33);
      Curve.arraycopy(
          serializedPublic, 0, badKeyType, 0, serializedPublic.length);
      badKeyType[0] = 0x01;
      Curve.decodePoint(badKeyType, 0);
      throw AssertionError('Should be bad key type');
    } on InvalidKeyException catch (e) {
      // good
    }

    var extraSpace = Uint8List(serializedPublic.length + 1);
    Curve.arraycopy(
        serializedPublic, 0, extraSpace, 0, serializedPublic.length);
    var extra = Curve.decodePoint(extraSpace, 0);

    var offsetSpace = Uint8List(serializedPublic.length + 1);
    Curve.arraycopy(
        serializedPublic, 0, offsetSpace, 1, serializedPublic.length);
    var offset = Curve.decodePoint(offsetSpace, 1);

    expect(serializedPublic, justRight.serialize());
    expect(extra.serialize(), serializedPublic);
    expect(offset.serialize(), serializedPublic);
  });
}

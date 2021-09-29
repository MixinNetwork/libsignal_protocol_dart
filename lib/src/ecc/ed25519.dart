import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as cr;
import 'package:ed25519_edwards/ed25519_edwards.dart';
// ignore: implementation_imports
import 'package:ed25519_edwards/src/edwards25519.dart';

import 'curve.dart';

Uint8List sign(Uint8List privateKey, Uint8List message, Uint8List random) {
  final A = ExtendedGroupElement();
  final publicKey = Uint8List(32);
  GeScalarMultBase(A, privateKey);
  A.ToBytes(publicKey);

  // Calculate r
  final diversifier = Uint8List.fromList([
    0xFE,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF
  ]);

  var output = AccumulatorSink<cr.Digest>();
  cr.sha512.startChunkedConversion(output)
    ..add(diversifier)
    ..add(privateKey)
    ..add(message)
    ..add(random)
    ..close();
  final r = output.events.single.bytes;

  final rReduced = Uint8List(32);
  ScReduce(rReduced, Uint8List.fromList(r));
  final R = ExtendedGroupElement();
  GeScalarMultBase(R, rReduced);

  final encodedR = Uint8List(32);
  R.ToBytes(encodedR);

  output = AccumulatorSink<cr.Digest>();
  cr.sha512.startChunkedConversion(output)
    ..add(encodedR)
    ..add(publicKey)
    ..add(message)
    ..close();
  final hramDigest = output.events.single.bytes;

  final hramDigestReduced = Uint8List(32);
  ScReduce(hramDigestReduced, Uint8List.fromList(hramDigest));

  final s = Uint8List(32);
  ScMulAdd(s, hramDigestReduced, privateKey, rReduced);

  final signature = Uint8List(64);
  Curve.arraycopy(encodedR, 0, signature, 0, 32);
  Curve.arraycopy(s, 0, signature, 32, 32);
  signature[63] |= publicKey[31] & 0x80;

  return signature;
}

// verify checks whether the message has a valid signature.
bool verifySig(Uint8List publicKey, Uint8List message, Uint8List signature) {
  publicKey[31] &= 0x7F;

  final edY = FieldElement();
  final one = FieldElement();
  final montX = FieldElement();
  final montXMinusOne = FieldElement();
  final montXPlusOne = FieldElement();
  FeFromBytes(montX, publicKey);
  FeOne(one);
  FeSub(montXMinusOne, montX, one);
  FeAdd(montXPlusOne, montX, one);
  FeInvert(montXPlusOne, montXPlusOne);
  FeMul(edY, montXMinusOne, montXPlusOne);

  // ignore: non_constant_identifier_names
  final A_ed = Uint8List(32);
  FeToBytes(A_ed, edY);

  A_ed[31] |= signature[63] & 0x80;
  signature[63] &= 0x7F;

// bool verify(PublicKey publicKey, Uint8List message, Uint8List sig) {
  return verify(PublicKey(A_ed.toList()), message, signature);
}

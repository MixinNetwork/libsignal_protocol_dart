import 'dart:typed_data';
import 'package:crypto/crypto.dart' as cr;
import 'package:convert/convert.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:ed25519_edwards/src/edwards25519.dart';

import 'Curve.dart';

Uint8List sign(Uint8List privateKey, Uint8List message, Uint8List random) {
  var A = ExtendedGroupElement();
  var publicKey = Uint8List(32);
  GeScalarMultBase(A, privateKey);
  A.ToBytes(publicKey);

  // Calculate r
  var diversifier = Uint8List.fromList([
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
  var input = cr.sha512.startChunkedConversion(output);
  input.add(diversifier);
  input.add(privateKey);
  input.add(message);
  input.add(random);
  input.close();
  var r = output.events.single.bytes;

  var rReduced = Uint8List(32);
  ScReduce(rReduced, r);
  var R = ExtendedGroupElement();
  GeScalarMultBase(R, rReduced);

  var encodedR = Uint8List(32);
  R.ToBytes(encodedR);

  output = AccumulatorSink<cr.Digest>();
  input = cr.sha512.startChunkedConversion(output);
  input.add(encodedR);
  input.add(publicKey);
  input.add(message);
  input.close();
  var hramDigest = output.events.single.bytes;

  var hramDigestReduced = Uint8List(32);
  ScReduce(hramDigestReduced, hramDigest);

  var s = Uint8List(32);
  ScMulAdd(s, hramDigestReduced, privateKey, rReduced);

  var signature = Uint8List(64);
  Curve.arraycopy(encodedR, 0, signature, 0, 32);
  Curve.arraycopy(s, 0, signature, 32, 32);
  signature[63] |= publicKey[31] & 0x80;

  return signature;
}

// verify checks whether the message has a valid signature.
bool verifySig(Uint8List publicKey, Uint8List message, Uint8List signature) {
  publicKey[31] &= 0x7F;

  var edY = FieldElement();
  var one = FieldElement();
  var montX = FieldElement();
  var montXMinusOne = FieldElement();
  var montXPlusOne = FieldElement();
  FeFromBytes(montX, publicKey);
  FeOne(one);
  FeSub(montXMinusOne, montX, one);
  FeAdd(montXPlusOne, montX, one);
  FeInvert(montXPlusOne, montXPlusOne);
  FeMul(edY, montXMinusOne, montXPlusOne);

  var A_ed = Uint8List(32);
  FeToBytes(A_ed, edY);

  A_ed[31] |= signature[63] & 0x80;
  signature[63] &= 0x7F;

// bool verify(PublicKey publicKey, Uint8List message, Uint8List sig) {
  return verify(PublicKey(A_ed.toList()), message, signature);
}

import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'ecc/Curve.dart';
import 'ecc/ECPublicKey.dart';

class IdentityKey {
  ECPublicKey _publicKey;

  IdentityKey(this._publicKey);

  IdentityKey.fromBytes(Uint8List bytes, int offset) {
    _publicKey = Curve.decodePoint(bytes, offset);
  }

  ECPublicKey getPublicKey() {
    return _publicKey;
  }

  Uint8List serialize() {
    return _publicKey.serialize();
  }

  String getFingerprint() {
    return hex.encode(_publicKey.serialize());
  }
}

// @Override
// public boolean equals(Object other) {
//   if (other == null)                   return false;
//   if (!(other instanceof IdentityKey)) return false;

//   return publicKey.equals(((IdentityKey) other).getPublicKey());
// }

// @Override
// public int hashCode() {
//   return publicKey.hashCode();
// }

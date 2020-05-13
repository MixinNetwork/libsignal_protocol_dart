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

  ECPublicKey get publicKey => _publicKey;

  Uint8List serialize() {
    return _publicKey.serialize();
  }

  String getFingerprint() {
    return hex.encode(_publicKey.serialize());
  }

  @override
  bool operator ==(other) {
    if (!(other is IdentityKey)) return false;

    var that = other as IdentityKey;
    return _publicKey == that._publicKey;
  }

  @override
  int get hashCode => _publicKey.hashCode;
}

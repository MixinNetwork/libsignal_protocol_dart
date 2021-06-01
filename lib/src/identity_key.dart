import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'ecc/curve.dart';
import 'ecc/ec_public_key.dart';

class IdentityKey {
  IdentityKey(this._publicKey);

  IdentityKey.fromBytes(Uint8List bytes, int offset) {
    _publicKey = Curve.decodePoint(bytes, offset);
  }

  late ECPublicKey _publicKey;

  ECPublicKey get publicKey => _publicKey;

  Uint8List serialize() => _publicKey.serialize();

  String getFingerprint() => hex.encode(_publicKey.serialize());

  @override
  bool operator ==(Object other) {
    if (other is! IdentityKey) return false;

    return _publicKey == other._publicKey;
  }

  @override
  int get hashCode => _publicKey.hashCode;
}

import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:meta/meta.dart';

import 'ecc/curve.dart';
import 'ecc/ec_public_key.dart';

@immutable
class IdentityKey {
  const IdentityKey(this._publicKey);

  factory IdentityKey.fromBytes(Uint8List bytes, int offset) =>
      IdentityKey(Curve.decodePoint(bytes, offset));

  final ECPublicKey _publicKey;

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

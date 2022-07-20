import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../eq.dart';

import 'curve.dart';
import 'ec_public_key.dart';

@immutable
class DjbECPublicKey extends ECPublicKey {
  DjbECPublicKey(this._publicKey);

  final Uint8List _publicKey;

  @override
  int getType() => Curve.djbType;

  @override
  Uint8List serialize() => Uint8List.fromList([Curve.djbType] + _publicKey);

  Uint8List get publicKey => _publicKey;

  @override
  int compareTo(ECPublicKey another) => decodeBigInt(publicKey)
      .compareTo(decodeBigInt((another as DjbECPublicKey).publicKey));

  @override
  bool operator ==(Object other) {
    if (other is! DjbECPublicKey) return false;
    return eq(_publicKey, other._publicKey);
  }

  @override
  int get hashCode => _publicKey.hashCode;

  BigInt decodeBigInt(List<int> bytes) {
    var result = BigInt.from(0);
    for (var i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }
}

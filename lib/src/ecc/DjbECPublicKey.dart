import 'dart:typed_data';

import '../util/ByteUtil.dart';
import 'package:pointycastle/src/utils.dart';

import 'Curve.dart';
import 'ECPublicKey.dart';

class DjbECPublicKey extends ECPublicKey {
  final Uint8List _publicKey;

  DjbECPublicKey(this._publicKey);

  @override
  int getType() {
    return Curve.djbType;
  }

  @override
  Uint8List serialize() {
    return ByteUtil.combine([
      Uint8List.fromList([Curve.djbType]),
      _publicKey
    ]);
  }

  Uint8List get publicKey => _publicKey;

  @override
  int compareTo(ECPublicKey another) {
    return decodeBigInt(publicKey)
        .compareTo(decodeBigInt((another as DjbECPublicKey).publicKey));
  }

  @override
  bool operator ==(other) {
    if (!(other is DjbECPublicKey)) return false;

    var that = other as DjbECPublicKey;
    return _publicKey == that._publicKey;
  }

  @override
  int get hashCode => _publicKey.hashCode;
}

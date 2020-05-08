import 'dart:typed_data';

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
    _publicKey.insert(0, Curve.djbType);
    return _publicKey;
  }

  Uint8List get publicKey => _publicKey;

  @override
  int compareTo(ECPublicKey another) {
    // return _publicKey == (another as DjbECPublicKey).getPublicKey();
    // return new BigInteger(publicKey).compareTo(new BigInteger(((DjbECPublicKey)another).publicKey));
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

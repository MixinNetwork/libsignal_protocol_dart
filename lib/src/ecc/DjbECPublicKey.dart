import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';

class DjbECPublicKey extends ECPublicKey {
  Uint8List _publicKey;

  DjbECPublicKey(Uint8List publicKey) {
    this._publicKey = publicKey;
  }
  @override
  int getType() {
    return Curve.djbType;
  }

  @override
  Uint8List serialize() {
    _publicKey.insert(0, Curve.djbType);
    return _publicKey;
  }

  getPublicKey() {
    return _publicKey;
  }

  @override
  int compareTo(ECPublicKey another) {
    // return _publicKey == (another as DjbECPublicKey).getPublicKey();
    // return new BigInteger(publicKey).compareTo(new BigInteger(((DjbECPublicKey)another).publicKey));
  }
  @override
  bool operator ==(other) {
    if (other == null) return false;
    if (!(other is DjbECPublicKey)) return false;

    DjbECPublicKey that = other as DjbECPublicKey;
    return this._publicKey == that._publicKey;
  }

  @override
  int get hashCode => _publicKey.hashCode;
}

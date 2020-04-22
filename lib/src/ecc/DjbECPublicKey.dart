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
}

//   @Override
//   public boolean equals(Object other) {
//     if (other == null)                      return false;
//     if (!(other instanceof DjbECPublicKey)) return false;

//     DjbECPublicKey that = (DjbECPublicKey)other;
//     return Arrays.equals(this.publicKey, that.publicKey);
//   }

//   @Override
//   public int hashCode() {
//     return Arrays.hashCode(publicKey);
//   }

//   @Override
//   public int compareTo(ECPublicKey another) {
//     return new BigInteger(publicKey).compareTo(new BigInteger(((DjbECPublicKey)another).publicKey));
//   }

// }

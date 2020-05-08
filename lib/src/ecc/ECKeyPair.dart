import 'ECPrivateKey.dart';
import 'ECPublicKey.dart';

class ECKeyPair {
  ECPublicKey _publicKey;
  ECPrivateKey _privateKey;

  ECKeyPair(ECPublicKey publicKey, ECPrivateKey privateKey) {
    this._publicKey = publicKey;
    this._privateKey = privateKey;
  }

  ECPublicKey getPublicKey() {
    return _publicKey;
  }

  ECPrivateKey getPrivateKey() {
    return _privateKey;
  }
}

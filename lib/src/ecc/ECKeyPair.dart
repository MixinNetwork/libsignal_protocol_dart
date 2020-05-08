import 'ECPrivateKey.dart';
import 'ECPublicKey.dart';

class ECKeyPair {
  final ECPublicKey _publicKey;
  final ECPrivateKey _privateKey;

  ECKeyPair(this._publicKey, this._privateKey);

  ECPublicKey getPublicKey() {
    return _publicKey;
  }

  ECPrivateKey getPrivateKey() {
    return _privateKey;
  }
}

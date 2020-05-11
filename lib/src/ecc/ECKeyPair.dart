import 'ECPrivateKey.dart';
import 'ECPublicKey.dart';

class ECKeyPair {
  final ECPublicKey _publicKey;
  final ECPrivateKey _privateKey;

  ECKeyPair(this._publicKey, this._privateKey);

  ECPublicKey get publicKey => _publicKey;

  ECPrivateKey get privateKey => _privateKey;
}

import 'ec_private_key.dart';
import 'ec_public_key.dart';

class ECKeyPair {
  ECKeyPair(this._publicKey, this._privateKey);

  final ECPublicKey _publicKey;
  final ECPrivateKey _privateKey;

  ECPublicKey get publicKey => _publicKey;

  ECPrivateKey get privateKey => _privateKey;
}

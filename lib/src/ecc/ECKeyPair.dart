import 'package:libsignalprotocoldart/src/ecc/ECPrivateKey.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';

class ECKeyPair {
  ECPublicKey publicKey;
  ECPrivateKey privateKey;

  ECKeyPair(ECPublicKey publicKey, ECPrivateKey privateKey) {
    this.publicKey = publicKey;
    this.privateKey = privateKey;
  }
}

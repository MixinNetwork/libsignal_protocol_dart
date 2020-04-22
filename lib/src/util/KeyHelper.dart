import 'package:libsignalprotocoldart/src/IdentityKey.dart';
import 'package:libsignalprotocoldart/src/IdentityKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/Curve.dart';

class KeyHelper {
  static IdentityKeyPair generateIdentityKeyPair() {
    var keyPair = Curve.generateKeyPair();
    var publicKey = IdentityKey(keyPair.getPublicKey());
    return IdentityKeyPair(publicKey, keyPair.getPrivateKey());
  }
}

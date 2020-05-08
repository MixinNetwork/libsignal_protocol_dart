import 'package:pointycastle/pointycastle.dart';

import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/Curve.dart';

class KeyHelper {
  static IdentityKeyPair generateIdentityKeyPair() {
    var keyPair = Curve.generateKeyPair();
    var publicKey = IdentityKey(keyPair.getPublicKey());
    return IdentityKeyPair(publicKey, keyPair.getPrivateKey());
  }

  static int integerMax = 0x7fffffff;

  static int generateRegistrationId(bool extendedRange) {
    var secureRandom = SecureRandom();
    if (extendedRange) {
      return secureRandom.nextBigInteger(integerMax - 1).toInt() + 1;
    } else {
      return secureRandom.nextBigInteger(16380).toInt() + 1;
    }
  }
}

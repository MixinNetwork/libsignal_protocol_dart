import 'dart:math';

import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/Curve.dart';

class KeyHelper {
  static IdentityKeyPair generateIdentityKeyPair() {
    var keyPair = Curve.generateKeyPair();
    var publicKey = IdentityKey(keyPair.publicKey);
    return IdentityKeyPair(publicKey, keyPair.privateKey);
  }

  static int integerMax = 0x7fffffff;

  static int generateRegistrationId(bool extendedRange) {
    final secureRandom = Random.secure();
    if (extendedRange) {
      return secureRandom.nextInt(integerMax - 1) + 1;
    } else {
      return secureRandom.nextInt(16380) + 1;
    }
  }
}

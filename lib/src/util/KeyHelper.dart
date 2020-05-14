import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';

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
    final secureRandom = SecureRandom('AES/CTR/PRNG');
    final key = Uint8List(16);
    final keyParam = KeyParameter(key);
    final params = ParametersWithIV(keyParam, Uint8List(16));

    secureRandom.seed(params);
    if (extendedRange) {
      return secureRandom.nextBigInteger(integerMax - 1).toInt() + 1;
    } else {
      return secureRandom.nextBigInteger(16380).toInt() + 1;
    }
  }
}

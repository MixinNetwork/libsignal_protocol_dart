import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';

import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../state/PreKeyRecord.dart';
import 'Medium.dart';

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

  static List<PreKeyRecord> generatePreKeys(int start, int count) {
    var results = <PreKeyRecord>[];
    start--;
    for (var i = 0; i < count; i++) {
      results.add(PreKeyRecord(
          ((start + i) % (Medium.MAX_VALUE - 1)) + 1, Curve.generateKeyPair()));
    }
    return results;
  }

  static ECKeyPair generateSenderSigningKey() {
    return Curve.generateKeyPair();
  }

  static Uint8List generateSenderKey() {
    var secureRandom = SecureRandom("AES/CTR/AUTO-SEED-PRNG");
    final key = Uint8List(32);
    final keyParam = KeyParameter(key);
    secureRandom.seed(keyParam);
    return secureRandom.nextBytes(32);
  }

  static int generateSenderKeyId() {
    final secureRandom = Random.secure();
    return secureRandom.nextInt(integerMax);
  }
}

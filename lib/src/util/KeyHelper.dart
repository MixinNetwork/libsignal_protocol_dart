import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../state/PreKeyRecord.dart';
import '../state/SignedPreKeyRecord.dart';
import 'Medium.dart';

class KeyHelper {
  static IdentityKeyPair generateIdentityKeyPair() {
    var keyPair = Curve.generateKeyPair();
    var publicKey = IdentityKey(keyPair.publicKey);
    return IdentityKeyPair(publicKey, keyPair.privateKey);
  }

  static int integerMax = 0x7fffffff;

  static int generateRegistrationId(bool extendedRange) {
    if (extendedRange) {
      return _random.nextInt(integerMax - 1) + 1;
    } else {
      return _random.nextInt(16380) + 1;
    }
  }

  static List<PreKeyRecord> generatePreKeys(int start, int count) {
    var results = <PreKeyRecord>[];
    start--;
    for (var i = 0; i < count; i++) {
      results.add(PreKeyRecord(
          ((start + i).remainder(Medium.MAX_VALUE - 1)) + 1,
          Curve.generateKeyPair()));
    }
    return results;
  }

  static SignedPreKeyRecord generateSignedPreKey(
      IdentityKeyPair identityKeyPair, int signedPreKeyId) {
    var keyPair = Curve.generateKeyPair();
    var signature = Curve.calculateSignature(
        identityKeyPair.getPrivateKey(), keyPair.publicKey.serialize());

    return SignedPreKeyRecord(signedPreKeyId,
        Int64(DateTime.now().millisecondsSinceEpoch), keyPair, signature);
  }

  static ECKeyPair generateSenderSigningKey() {
    return Curve.generateKeyPair();
  }

  static Uint8List generateSenderKey() {
    return generateRandomBytes();
  }

  static int generateSenderKeyId() {
    return _random.nextInt(integerMax);
  }

  static final Random _random = Random.secure();

  static Uint8List generateRandomBytes([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return Uint8List.fromList(values);
  }
}

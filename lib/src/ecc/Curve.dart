import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import '../InvalidKeyException.dart';
import 'DjbECPrivateKey.dart';
import 'DjbECPublicKey.dart';
import 'ECKeyPair.dart';
import 'ECPrivateKey.dart';
import 'ECPublicKey.dart';
import 'SignCurve25519.dart';

class Curve {
  static const int djbType = 0x05;

  static ECKeyPair generateKeyPair() {
    final keyPair = x25519.newKeyPairSync();
    return ECKeyPair(
        DjbECPublicKey(Uint8List.fromList(keyPair.publicKey.bytes)),
        DjbECPrivateKey(Uint8List.fromList(keyPair.privateKey.extractSync())));
  }

  static ECPublicKey decodePoint(Uint8List bytes, int offset) {
    if (bytes == null || bytes.length - offset < 1) {
      throw InvalidKeyException('No key type identifier');
    }

    var type = bytes[offset] & 0xFF;

    switch (type) {
      case Curve.djbType:
        if (bytes.length - offset < 33) {
          throw InvalidKeyException(
              'Bad key length: ' + bytes.length.toString());
        }

        var keyBytes = Uint8List(32);
        arraycopy(bytes, offset + 1, keyBytes, 0, keyBytes.length);
        return DjbECPublicKey(keyBytes);
      default:
        throw InvalidKeyException('Bad key type: ' + type.toString());
    }
  }

  static void arraycopy(
      List src, int srcPos, List dest, int destPos, int length) {
    dest.setRange(destPos, length + destPos, src, srcPos);
  }

  static ECPrivateKey decodePrivatePoint(Uint8List bytes) {
    return DjbECPrivateKey(bytes);
  }

  static Uint8List calculateAgreement(
      ECPublicKey publicKey, ECPrivateKey privateKey) {
    if (publicKey == null) {
      throw Exception('publicKey value is null');
    }

    if (privateKey == null) {
      throw Exception('privateKey value is null');
    }
    if (publicKey.getType() != privateKey.getType()) {
      throw Exception('Public and private keys must be of the same type!');
    }

    if (publicKey.getType() == djbType) {
      var secretKey = x25519.sharedSecretSync(
        localPrivateKey: PrivateKey((privateKey as DjbECPrivateKey).privateKey),
        remotePublicKey: PublicKey((publicKey as DjbECPublicKey).publicKey),
      );
      return Uint8List.fromList(secretKey.extractSync());
    } else {
      throw Exception('Unknown type: ' + publicKey.getType().toString());
    }
  }

  static bool verifySignature(
      ECPublicKey signingKey, Uint8List message, Uint8List signature) {
    if (signingKey == null || message == null || signature == null) {
      throw InvalidKeyException('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      if (signature.length != 64) {
        return false;
      }

      return verify(
          (signingKey as DjbECPublicKey).publicKey, message, signature);
    } else {
      throw InvalidKeyException(
          'Unknown Signing Key type' + signingKey.getType().toString());
    }
  }

  static Uint8List calculateSignature(
      ECPrivateKey signingKey, Uint8List message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      return sign((signingKey as DjbECPrivateKey).serialize(), message);
    } else {
      throw Exception(
          'Unknown Signing Key type' + signingKey.getType().toString());
    }
  }

  static Uint8List calculateVrfSignature(
      ECPrivateKey signingKey, Uint8List message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw Exception(
          'Unknown Signing Key type' + signingKey.getType().toString());
    }
  }

  static Uint8List verifyVrfSignature(
      ECPublicKey signingKey, Uint8List message, Uint8List signature) {
    if (signingKey == null || message == null || signature == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw Exception(
          'Unknown Signing Key type' + signingKey.getType().toString());
    }
  }
}

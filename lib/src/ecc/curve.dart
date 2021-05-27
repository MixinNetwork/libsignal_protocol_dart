import 'dart:typed_data';

import 'package:x25519/x25519.dart' as x25519;

import '../invalid_key_exception.dart';
import '../util/key_helper.dart';
import 'djb_ec_private_key.dart';
import 'djb_ec_public_key.dart';
import 'ec_key_pair.dart';
import 'ec_private_key.dart';
import 'ec_public_key.dart';
import 'ed25519.dart';

class Curve {
  static const int djbType = 0x05;

  static ECKeyPair generateKeyPair() {
    final keyPair = x25519.generateKeyPair();
    return ECKeyPair(DjbECPublicKey(Uint8List.fromList(keyPair.publicKey)),
        DjbECPrivateKey(Uint8List.fromList(keyPair.privateKey)));
  }

  static ECKeyPair generateKeyPairFromPrivate(List<int> private) {
    if (private.length != 32) {
      throw InvalidKeyException(
          'Invalid private key length: ${private.length}');
    }
    final public = List<int>.filled(32, 0);

    private[0] &= 248;
    private[31] &= 127;
    private[31] |= 64;

    x25519.ScalarBaseMult(public, private);

    return ECKeyPair(DjbECPublicKey(Uint8List.fromList(public)),
        DjbECPrivateKey(Uint8List.fromList(private)));
  }

  static ECPublicKey decodePointList(List<int> bytes, int offset) =>
      decodePoint(Uint8List.fromList(bytes), offset);

  static ECPublicKey decodePoint(Uint8List bytes, int offset) {
    if (bytes.length - offset < 1) {
      throw InvalidKeyException('No key type identifier');
    }

    final type = bytes[offset] & 0xFF;

    switch (type) {
      case Curve.djbType:
        if (bytes.length - offset < 33) {
          throw InvalidKeyException('Bad key length: ${bytes.length}');
        }

        final keyBytes = Uint8List(32);
        arraycopy(bytes, offset + 1, keyBytes, 0, keyBytes.length);
        return DjbECPublicKey(keyBytes);
      default:
        throw InvalidKeyException('Bad key type: $type');
    }
  }

  static void arraycopy(
      List src, int srcPos, List dest, int destPos, int length) {
    dest.setRange(destPos, length + destPos, src, srcPos);
  }

  static ECPrivateKey decodePrivatePoint(Uint8List bytes) =>
      DjbECPrivateKey(bytes);

  static Uint8List calculateAgreement(
      ECPublicKey? publicKey, ECPrivateKey? privateKey) {
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
      final secretKey = x25519.X25519(
        List<int>.from((privateKey as DjbECPrivateKey).privateKey),
        List<int>.from((publicKey as DjbECPublicKey).publicKey),
      );
      return secretKey;
    } else {
      throw Exception('Unknown type: ${publicKey.getType()}');
    }
  }

  static bool verifySignature(
      ECPublicKey? signingKey, Uint8List? message, Uint8List? signature) {
    if (signingKey == null || message == null || signature == null) {
      throw InvalidKeyException('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      if (signature.length != 64) {
        return false;
      }

      final publicKey = (signingKey as DjbECPublicKey).publicKey;
      return verifySig(publicKey, message, signature);
    } else {
      throw InvalidKeyException(
          'Unknown Signing Key type${signingKey.getType()}');
    }
  }

  static Uint8List calculateSignature(
      ECPrivateKey? signingKey, Uint8List? message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      final privateKey = signingKey.serialize();
      final random = generateRandomBytes();

      return sign(privateKey, message, random);
    } else {
      throw Exception('Unknown Signing Key type${signingKey.getType()}');
    }
  }

  // ignore: missing_return
  static Uint8List calculateVrfSignature(
      ECPrivateKey? signingKey, Uint8List? message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw Exception('Unknown Signing Key type${signingKey.getType()}');
    }
    return Uint8List(0);
  }

  static Uint8List verifyVrfSignature(
      ECPublicKey? signingKey, Uint8List? message, Uint8List? signature) {
    if (signingKey == null || message == null || signature == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw Exception('Unknown Signing Key type${signingKey.getType()}');
    }
    return Uint8List(0);
  }
}

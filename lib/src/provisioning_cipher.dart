import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'cbc.dart';
import 'ecc/curve.dart';
import 'ecc/ec_public_key.dart';
import 'eq.dart';
import 'invalid_mac_exception.dart';
import 'kdf/derived_root_secrets.dart';
import 'kdf/hkdfv3.dart';
import 'legacy_message_exception.dart';
import 'util/byte_util.dart';

const String provision = 'Mixin Provisioning Message';

class ProvisionEnvelope {
  ProvisionEnvelope(this.publicKey, this.body);

  ProvisionEnvelope.fromJson(Map<String, dynamic> json)
      : publicKey = base64Decode(json['public_key'] as String),
        body = base64Decode(json['body'] as String);

  final Uint8List publicKey;
  final Uint8List body;

  Map<String, dynamic> toJson() => {
        'public_key': base64Encode(publicKey),
        'body': base64Encode(body),
      };
}

Uint8List decrypt(String privateKey, String content) {
  final ourPrivateKey = base64Decode(privateKey);
  final envelopeDecode = base64Decode(content);

  final map = jsonDecode(String.fromCharCodes(envelopeDecode));
  final provisionEnvelope =
      ProvisionEnvelope.fromJson(map as Map<String, dynamic>);
  final publicKeyable = Curve.decodePoint(provisionEnvelope.publicKey, 0);
  final message = provisionEnvelope.body;
  if (message[0] != 1) {
    throw LegacyMessageException('Invalid version');
  }
  final iv = Uint8List.fromList(message.getRange(1, 16 + 1).toList());
  final mac = message.getRange(message.length - 32, message.length).toList();
  final ivAndCiphertext =
      Uint8List.fromList(message.getRange(0, message.length - 32).toList());
  final cipherText = Uint8List.fromList(
      message.getRange(16 + 1, message.length - 32).toList());
  final sharedSecret = Curve.calculateAgreement(
      publicKeyable, Curve.decodePrivatePoint(ourPrivateKey));

  final derivedSecretBytes = HKDFv3().deriveSecrets(sharedSecret,
      Uint8List.fromList(utf8.encode(provision)), DerivedRootSecrets.size);

  final aesKey =
      Uint8List.fromList(derivedSecretBytes.getRange(0, 32).toList());
  final macKey = Uint8List.fromList(
      derivedSecretBytes.getRange(32, derivedSecretBytes.length).toList());

  if (!verifyMAC(macKey, ivAndCiphertext, mac)) {
    throw InvalidMacException("MAC doesn't match!");
  }
  final plaintext = aesCbcDecrypt(aesKey, iv, cipherText);
  return plaintext;
}

bool verifyMAC(Uint8List key, Uint8List input, List<int> mac) {
  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(input);
  return eq(digest.bytes, mac);
}

class ProvisioningCipher {
  ProvisioningCipher(this._theirPublicKey);

  final ECPublicKey _theirPublicKey;

  Uint8List encrypt(Uint8List message) {
    final ourKeyPair = Curve.generateKeyPair();
    final sharedSecret =
        Curve.calculateAgreement(_theirPublicKey, ourKeyPair.privateKey);
    final derivedSecret = HKDFv3().deriveSecrets(
        sharedSecret, Uint8List.fromList(utf8.encode(provision)), 64);
    final parts = ByteUtil.splitTwo(derivedSecret, 32, 32);

    final version = Uint8List.fromList([1]);
    final ciphertext = getCiphertext(parts[0], message);
    final mac = _getMac(parts[1], ByteUtil.combine([version, ciphertext]));
    final body = ByteUtil.combine([version, ciphertext, mac]);
    final envelope = ProvisionEnvelope(ourKeyPair.publicKey.serialize(), body);
    final result = jsonEncode(envelope);
    return Uint8List.fromList(utf8.encode(result));
  }

  Uint8List getCiphertext(Uint8List key, Uint8List message) {
    final iv = Uint8List(16);
    final m = aesCbcEncrypt(key, iv, message);
    return ByteUtil.combine([iv, m]);
  }

  Uint8List _getMac(Uint8List key, Uint8List message) {
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(message);
    return Uint8List.fromList(digest.bytes);
  }
}

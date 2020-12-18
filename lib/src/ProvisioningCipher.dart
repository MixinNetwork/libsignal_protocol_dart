import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'InvalidMacException.dart';
import 'LegacyMessageException.dart';
import 'cbc.dart';
import 'ecc/Curve.dart';
import 'ecc/ECPublicKey.dart';
import 'eq.dart';
import 'kdf/DerivedRootSecrets.dart';
import 'kdf/HKDFv3.dart';
import 'util/ByteUtil.dart';

final String PROVISION = "Mixin Provisioning Message";

class ProvisionEnvelope {
  final Uint8List public_key;
  final Uint8List body;

  ProvisionEnvelope(this.public_key, this.body);

  ProvisionEnvelope.fromJson(Map<String, dynamic> json)
      : public_key = base64Decode(json['public_key']),
        body = base64Decode(json['body']);

  Map<String, dynamic> toJson() => {
        'public_key': base64Encode(public_key),
        'body': base64Encode(body),
      };
}

Uint8List decrypt(String privateKey, String content) {
  var ourPrivateKey = base64Decode(privateKey);
  var envelopeDecode = base64Decode(content);

  var map = jsonDecode(String.fromCharCodes(envelopeDecode));
  var provisionEnvelope = ProvisionEnvelope.fromJson(map);
  var publicKeyable = Curve.decodePoint(provisionEnvelope.public_key, 0);
  var message = provisionEnvelope.body;
  if (message[0] != 1) {
    throw LegacyMessageException('Invalid version');
  }
  var iv = Uint8List.fromList(message.getRange(1, 16 + 1).toList());
  var mac = message.getRange(message.length - 32, message.length).toList();
  var ivAndCiphertext =
      Uint8List.fromList(message.getRange(0, message.length - 32).toList());
  var cipherText = Uint8List.fromList(
      message.getRange(16 + 1, message.length - 32).toList());
  var sharedSecret = Curve.calculateAgreement(
      publicKeyable, Curve.decodePrivatePoint(ourPrivateKey));

  var derivedSecretBytes = HKDFv3().deriveSecrets(
      sharedSecret, utf8.encode(PROVISION), DerivedRootSecrets.SIZE);

  var aesKey = Uint8List.fromList(derivedSecretBytes.getRange(0, 32).toList());
  var macKey = Uint8List.fromList(
      derivedSecretBytes.getRange(32, derivedSecretBytes.length).toList());

  if (!verifyMAC(macKey, ivAndCiphertext, mac)) {
    throw InvalidMacException("MAC doesn't match!");
  }
  var plaintext = aesCbcDecrypt(aesKey, iv, cipherText);
  return plaintext;
}

bool verifyMAC(Uint8List key, Uint8List input, List<int> mac) {
  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(input);
  return eq(digest.bytes, mac);
}

class ProvisioningCipher {
  final ECPublicKey _theirPublicKey;

  ProvisioningCipher(this._theirPublicKey);

  Uint8List encrypt(Uint8List message) {
    var ourKeyPair = Curve.generateKeyPair();
    var sharedSecret =
        Curve.calculateAgreement(_theirPublicKey, ourKeyPair.privateKey);
    var derivedSecret =
        HKDFv3().deriveSecrets(sharedSecret, utf8.encode(PROVISION), 64);
    var parts = ByteUtil.splitTwo(derivedSecret, 32, 32);

    var version = Uint8List.fromList([1]);
    var ciphertext = getCiphertext(parts[0], message);
    var mac = _getMac(parts[1], ByteUtil.combine([version, ciphertext]));
    var body = ByteUtil.combine([version, ciphertext, mac]);
    var envelope = ProvisionEnvelope(ourKeyPair.publicKey.serialize(), body);
    var result = jsonEncode(envelope);
    return utf8.encode(result);
  }

  Uint8List getCiphertext(Uint8List key, Uint8List message) {
    var iv = Uint8List(16);
    var m = aesCbcEncrypt(key, iv, message);
    return ByteUtil.combine([iv, m]);
  }

  Uint8List _getMac(Uint8List key, Uint8List message) {
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(message);
    return Uint8List.fromList(digest.bytes);
  }
}

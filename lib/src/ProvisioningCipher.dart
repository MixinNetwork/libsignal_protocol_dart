import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:libsignal_protocol_dart/src/ecc/ECPublicKey.dart';

import 'cbc.dart';
import 'ecc/Curve.dart';
import 'kdf/HKDFv3.dart';
import 'util/ByteUtil.dart';

class ProvisionEnvelope {
  Uint8List public_key;
  Uint8List body;

  ProvisionEnvelope(Uint8List publicKey, Uint8List body) {
    this.public_key = publicKey;
    this.body = body;
  }
}

class ProvisioningCipher {
  ECPublicKey _theirPublicKey;

  Uint8List encrypt(Uint8List message) {
    var ourKeyPair = Curve.generateKeyPair();
    var sharedSecret =
        Curve.calculateAgreement(_theirPublicKey, ourKeyPair.privateKey);
    var derivedSecret = HKDFv3().deriveSecrets(
        sharedSecret, utf8.encode("Mixin Provisioning Message"), 64);
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
    var digest = hmacSha256.convert(key);
    return Uint8List.fromList(digest.bytes);
  }
}

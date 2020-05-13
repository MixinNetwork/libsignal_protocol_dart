import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import '../kdf/DerivedMessageSecrets.dart';
import '../kdf/HKDF.dart';
import '../ratchet/MessageKeys.dart';

class ChainKey {
  static final Uint8List MESSAGE_KEY_SEED = Uint8List.fromList([0x01]);
  static final Uint8List CHAIN_KEY_SEED = Uint8List.fromList([0x02]);

  final HKDF kdf;
  final Uint8List key;
  final int index;

  ChainKey(this.kdf, this.key, this.index);

  Uint8List getKey() {
    return key;
  }

  int getIndex() {
    return index;
  }

  ChainKey getNextChainKey() {
    var nextKey = _getBaseMaterial(CHAIN_KEY_SEED);
    return ChainKey(kdf, nextKey, index + 1);
  }

  MessageKeys getMessageKeys() {
    var bytes = utf8.encode('WhisperMessageKeys');

    var inputKeyMaterial = _getBaseMaterial(MESSAGE_KEY_SEED);
    var keyMaterialBytes =
        kdf.deriveSecrets(inputKeyMaterial, bytes, DerivedMessageSecrets.SIZE);
    var keyMaterial = DerivedMessageSecrets(keyMaterialBytes);

    return MessageKeys(keyMaterial.getCipherKey(), keyMaterial.getMacKey(),
        keyMaterial.getIv(), index);
  }

  Uint8List _getBaseMaterial(Uint8List seed) {
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(seed);
    return digest.bytes;
  }
}

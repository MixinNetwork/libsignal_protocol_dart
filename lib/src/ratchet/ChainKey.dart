import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:libsignalprotocoldart/src/kdf/DerivedMessageSecrets.dart';
import 'package:libsignalprotocoldart/src/kdf/HKDF.dart';
import 'package:libsignalprotocoldart/src/ratchet/MessageKeys.dart';

class ChainKey {
  static final Uint8List MESSAGE_KEY_SEED = Uint8List.fromList([0x01]);
  static final Uint8List CHAIN_KEY_SEED = Uint8List.fromList([0x02]);

  final HKDF kdf;
  final Uint8List key;
  final int index;

  ChainKey(this.kdf, this.key, this.index) {}

  Uint8List getKey() {
    return key;
  }

  int getIndex() {
    return index;
  }

  ChainKey getNextChainKey() {
    Uint8List nextKey = _getBaseMaterial(CHAIN_KEY_SEED);
    return new ChainKey(kdf, nextKey, index + 1);
  }

  MessageKeys getMessageKeys() {
    List<int> bytes = utf8.encode("WhisperMessageKeys");

    Uint8List inputKeyMaterial = _getBaseMaterial(MESSAGE_KEY_SEED);
    Uint8List keyMaterialBytes =
        kdf.deriveSecrets(inputKeyMaterial, bytes, DerivedMessageSecrets.SIZE);
    DerivedMessageSecrets keyMaterial =
        new DerivedMessageSecrets(keyMaterialBytes);

    return MessageKeys(keyMaterial.getCipherKey(), keyMaterial.getMacKey(),
        keyMaterial.getIv(), index);
  }

  Uint8List _getBaseMaterial(Uint8List seed) {
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(seed);
    return digest.bytes;
  }
}

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import '../kdf/derived_message_secrets.dart';
import '../kdf/hkdf.dart';
import '../ratchet/message_keys.dart';

class ChainKey {
  ChainKey(this._kdf, this._key, this._index);

  static final Uint8List messageKeySeed = Uint8List.fromList([0x01]);
  static final Uint8List chainKeySeed = Uint8List.fromList([0x02]);

  final HKDF _kdf;
  final Uint8List _key;
  final int _index;

  Uint8List get key => _key;

  int get index => _index;

  ChainKey getNextChainKey() {
    final nextKey = _getBaseMaterial(chainKeySeed);
    return ChainKey(_kdf, nextKey, _index + 1);
  }

  MessageKeys getMessageKeys() {
    final bytes = Uint8List.fromList(utf8.encode('WhisperMessageKeys'));

    final inputKeyMaterial = _getBaseMaterial(messageKeySeed);
    final keyMaterialBytes =
        _kdf.deriveSecrets(inputKeyMaterial, bytes, DerivedMessageSecrets.size);
    final keyMaterial = DerivedMessageSecrets(keyMaterialBytes);

    return MessageKeys(keyMaterial.getCipherKey(), keyMaterial.getMacKey(),
        keyMaterial.getIv(), _index);
  }

  Uint8List _getBaseMaterial(Uint8List seed) {
    final hmacSha256 = Hmac(sha256, _key);
    final digest = hmacSha256.convert(seed);
    return Uint8List.fromList(digest.bytes);
  }
}

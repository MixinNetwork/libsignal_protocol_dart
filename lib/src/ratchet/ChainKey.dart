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

  final HKDF _kdf;
  final Uint8List _key;
  final int _index;

  ChainKey(this._kdf, this._key, this._index);

  Uint8List get key => _key;

  int get index => _index;

  ChainKey getNextChainKey() {
    var nextKey = _getBaseMaterial(CHAIN_KEY_SEED);
    return ChainKey(_kdf, nextKey, _index + 1);
  }

  MessageKeys getMessageKeys() {
    var bytes = Uint8List.fromList(utf8.encode('WhisperMessageKeys'));

    var inputKeyMaterial = _getBaseMaterial(MESSAGE_KEY_SEED);
    var keyMaterialBytes =
        _kdf.deriveSecrets(inputKeyMaterial, bytes, DerivedMessageSecrets.SIZE);
    var keyMaterial = DerivedMessageSecrets(keyMaterialBytes);

    return MessageKeys(keyMaterial.getCipherKey(), keyMaterial.getMacKey(),
        keyMaterial.getIv(), _index);
  }

  Uint8List _getBaseMaterial(Uint8List seed) {
    var hmacSha256 = Hmac(sha256, _key);
    var digest = hmacSha256.convert(seed);
    return Uint8List.fromList(digest.bytes);
  }
}

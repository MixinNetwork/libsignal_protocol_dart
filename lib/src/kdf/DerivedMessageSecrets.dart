import 'dart:typed_data';

import '../util/ByteUtil.dart';

class DerivedMessageSecrets {
  static final int SIZE = 80;
  static final int _CIPHER_KEY_LENGTH = 32;
  static final int _MAC_KEY_LENGTH = 32;
  static final int _IV_LENGTH = 16;

  Uint8List _cipherKey;
  Uint8List _macKey;
  Uint8List _iv;

  DerivedMessageSecrets(Uint8List okm) {
    var keys =
        ByteUtil.split(okm, _CIPHER_KEY_LENGTH, _MAC_KEY_LENGTH, _IV_LENGTH);

    _cipherKey = keys[0];
    _macKey = keys[1];
    _iv = keys[2];
  }

  Uint8List getCipherKey() {
    return _cipherKey;
  }

  Uint8List getMacKey() {
    return _macKey;
  }

  Uint8List getIv() {
    return _iv;
  }
}

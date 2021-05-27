import 'dart:typed_data';

import '../util/byte_util.dart';

class DerivedMessageSecrets {
  DerivedMessageSecrets(Uint8List okm) {
    final keys =
        ByteUtil.split(okm, _CIPHER_KEY_LENGTH, _MAC_KEY_LENGTH, _IV_LENGTH);

    _cipherKey = keys[0];
    _macKey = keys[1];
    _iv = keys[2];
  }

  static const int SIZE = 80;
  static const int _CIPHER_KEY_LENGTH = 32;
  static const int _MAC_KEY_LENGTH = 32;
  static const int _IV_LENGTH = 16;

  late Uint8List _cipherKey;
  late Uint8List _macKey;
  late Uint8List _iv;

  Uint8List getCipherKey() => _cipherKey;

  Uint8List getMacKey() => _macKey;

  Uint8List getIv() => _iv;
}

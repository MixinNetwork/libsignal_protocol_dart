import 'dart:typed_data';

import '../util/byte_util.dart';

class DerivedMessageSecrets {
  DerivedMessageSecrets(Uint8List okm) {
    final keys =
        ByteUtil.split(okm, _cipherKeyLength, _macKeyLength, _ivLength);

    _cipherKey = keys[0];
    _macKey = keys[1];
    _iv = keys[2];
  }

  static const int size = 80;
  static const int _cipherKeyLength = 32;
  static const int _macKeyLength = 32;
  static const int _ivLength = 16;

  late Uint8List _cipherKey;
  late Uint8List _macKey;
  late Uint8List _iv;

  Uint8List getCipherKey() => _cipherKey;

  Uint8List getMacKey() => _macKey;

  Uint8List getIv() => _iv;
}

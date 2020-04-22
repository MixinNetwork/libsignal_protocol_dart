import 'dart:typed_data';

abstract class ECPublicKey {
  static const int KEY_SIZE = 33;

  Uint8List serialize();
  int getType();
}

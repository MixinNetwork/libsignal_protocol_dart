import 'dart:typed_data';

abstract class ECPublicKey implements Comparable<ECPublicKey> {
  static const int KEY_SIZE = 33;

  Uint8List serialize();
  int getType();
}

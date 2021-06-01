import 'dart:typed_data';

abstract class ECPublicKey implements Comparable<ECPublicKey> {
  static const int keySize = 33;

  Uint8List serialize();
  int getType();
}

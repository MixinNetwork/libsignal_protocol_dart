import 'dart:typed_data';

abstract class ECPrivateKey {
  Uint8List serialize();
  int getType();
}

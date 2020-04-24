import 'dart:typed_data';

class MessageKeys {
  final Uint8List cipherKey;
  final Uint8List macKey;
  final Uint8List iv;
  final int counter;

  MessageKeys(this.cipherKey, this.macKey, this.iv, this.counter) {}

  Uint8List getCipherKey() {
    return cipherKey;
  }

  Uint8List getMacKey() {
    return macKey;
  }

  Uint8List getIv() {
    return iv;
  }

  int getCounter() {
    return counter;
  }
}

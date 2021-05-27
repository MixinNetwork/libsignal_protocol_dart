import 'dart:typed_data';

class MessageKeys {
  MessageKeys(this.cipherKey, this.macKey, this.iv, this.counter);

  final Uint8List cipherKey;
  final Uint8List macKey;
  final Uint8List iv;
  final int counter;

  Uint8List getCipherKey() => cipherKey;

  Uint8List getMacKey() => macKey;

  Uint8List getIv() => iv;

  int getCounter() => counter;
}

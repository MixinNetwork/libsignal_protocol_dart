import 'dart:typed_data';

abstract class DecryptionCallback {
  void handlePlaintext(Uint8List plaintext);
}

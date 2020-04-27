import 'dart:typed_data';

abstract class DecryptionCallback {
  handlePlaintext(Uint8List plaintext);
}
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

Uint8List aesCbcEncrypt(Uint8List key, Uint8List iv, Uint8List plaintext) {
  return aesCbc.encryptSync(plaintext,
      secretKey: SecretKey(key), nonce: Nonce(iv));
}

Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List ciphertext) {
  return aesCbc.decryptSync(ciphertext,
      secretKey: SecretKey(key), nonce: Nonce(iv));
}

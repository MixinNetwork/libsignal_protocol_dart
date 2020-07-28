import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

Uint8List aesCbcEncrypt(Uint8List key, Uint8List ivBytes, Uint8List plainText) {
  final k = Key(key);
  final iv = IV(ivBytes);

  final encrypter = Encrypter(AES(k, mode: AESMode.cbc));
  final encrypted = encrypter.encryptBytes(plainText, iv: iv);
  return encrypted.bytes;
}

Uint8List aesCbcDecrypt(
    Uint8List key, Uint8List ivBytes, Uint8List cipherText) {
  final k = Key(key);
  final iv = IV(ivBytes);

  final encrypter = Encrypter(AES(k, mode: AESMode.cbc));
  final decrypted = encrypter.decryptBytes(Encrypted(cipherText), iv: iv);
  return Uint8List.fromList(decrypted);
}

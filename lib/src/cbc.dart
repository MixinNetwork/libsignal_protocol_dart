import 'dart:typed_data';
import 'package:pointycastle/api.dart';

Uint8List aesCbcEncrypt(Uint8List key, Uint8List iv, Uint8List plaintext) {
  CipherParameters params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv), null);
  var cipher = PaddedBlockCipher('AES/CBC/PKCS7');
  cipher.init(true, params);
  return cipher.process(plaintext);
}

Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List ciphertext) {
  CipherParameters params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv), null);
  var cipher = PaddedBlockCipher('AES/CBC/PKCS7');
  cipher.init(false, params);
  return cipher.process(ciphertext);
}

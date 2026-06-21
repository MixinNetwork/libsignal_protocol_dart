import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import 'invalid_message_exception.dart';

Uint8List aesCbcEncrypt(Uint8List key, Uint8List iv, Uint8List plaintext) {
  final paddedPlaintext = pad(plaintext, 16);
  final cbc = CBCBlockCipher(AESEngine())
    ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

  final cipherText = Uint8List(paddedPlaintext.length); // allocate space
  var offset = 0;
  while (offset < paddedPlaintext.length) {
    offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
  }
  assert(offset == paddedPlaintext.length);
  return cipherText;
}

Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
  // Reject malformed ciphertext up front: it must be a non-zero multiple of the
  // AES block size, otherwise processBlock would read past the buffer or the
  // length assert would be silently stripped in release builds.
  if (cipherText.isEmpty || cipherText.length % 16 != 0) {
    throw InvalidMessageException(
        'Ciphertext length is not a non-zero multiple of the block size: '
        '${cipherText.length}');
  }

  final cbc = CBCBlockCipher(AESEngine())
    ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

  final paddedPlainText = Uint8List(cipherText.length); // allocate space
  var offset = 0;
  while (offset < cipherText.length) {
    offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
  }
  assert(offset == cipherText.length);
  try {
    return unpad(paddedPlainText);
    // ignore: avoid_catching_errors
  } on ArgumentError catch (e) {
    // PKCS7Padding.padCount throws ArgumentError on corrupted padding; surface
    // it as a typed protocol exception like the canonical implementation does.
    throw InvalidMessageException('Invalid padding: ${e.message}');
  }
}

Uint8List pad(Uint8List bytes, int blockSize) {
  final padLength = blockSize - (bytes.length % blockSize);
  final padded = Uint8List(bytes.length + padLength)..setAll(0, bytes);
  PKCS7Padding().addPadding(padded, bytes.length);
  return padded;
}

Uint8List unpad(Uint8List padded) =>
    padded.sublist(0, padded.length - PKCS7Padding().padCount(padded));

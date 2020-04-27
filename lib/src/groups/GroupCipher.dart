import 'dart:math';
import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/groups/ratchet/SenderChainKey.dart';
import 'package:pointycastle/api.dart';

import '../DecryptionCallback.dart';
import '../DuplicateMessageException.dart';
import '../InvalidMessageException.dart';
import 'SenderKeyName.dart';
import 'ratchet/SenderMessageKey.dart';
import 'state/SenderKeyState.dart';
import 'state/SenderKeyStore.dart';

class GroupCipher {
  SenderKeyStore _senderKeyStore;
  SenderKeyName _senderKeyId;

  GroupCipher(this._senderKeyStore, this._senderKeyId);

  Uint8List encrypt(Uint8List paddedPlaintext) {

  }

  Uint8List decrypt(Uint8List senderKeyMessageBytes) {

  }

  Uint8List decryptWithCallback(Uint8List senderKeyMessageBytes, DecryptionCallback callback) {

  }

  SenderMessageKey getSenderKey(SenderKeyState senderKeyState, int iteration) {
    SenderChainKey senderChainKey = senderKeyState.senderChainKey;
    if (senderChainKey.iteration > iteration) {
      if (senderKeyState.hasSenderMessageKey(iteration)) {
        return senderKeyState.removeSenderMessageKey(iteration);
      } else {
        throw DuplicateMessageException('Received message with old counter: '
            '${senderChainKey.iteration} , $iteration');
      }
    }

    if (iteration - senderChainKey.iteration > 2000) {
      throw new InvalidMessageException("Over 2000 messages into the future!");
    }

    while (senderChainKey.iteration < iteration) {
      senderKeyState.addSenderMessageKey(senderChainKey.senderMessageKey);
      senderChainKey = senderChainKey.next;
    }

    senderKeyState.senderChainKey = senderChainKey.next;
    return senderChainKey.senderMessageKey;
  }

  Uint8List getPlainText(Uint8List iv, Uint8List key, Uint8List ciphertext) {
    CipherParameters params = PaddedBlockCipherParameters(
        ParametersWithIV(KeyParameter(key), iv), null);
    var cipher = PaddedBlockCipher('AES/CBC/PKCS5');
    cipher.init(false, params);
    return cipher.process(ciphertext);
  }

  Uint8List getCipherText(Uint8List iv, Uint8List key, Uint8List plaintext) {
    CipherParameters params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv), null);
    var cipher = PaddedBlockCipher('AES/CBC/PKCS5');
    cipher.init(true, params);
    return cipher.process(plaintext);
  }
}

class NullDecryptionCallback extends DecryptionCallback {
  @override
  handlePlaintext(Uint8List plaintext) {}
}
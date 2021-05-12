import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/cbc.dart';

import '../DecryptionCallback.dart';
import '../DuplicateMessageException.dart';
import '../InvalidKeyIdException.dart';
import '../InvalidMessageException.dart';
import '../InvalidKeyException.dart';
import '../NoSessionException.dart';
import '../protocol/SenderKeyMessage.dart';
import 'SenderKeyName.dart';
import 'ratchet/SenderMessageKey.dart';
import 'state/SenderKeyState.dart';
import 'state/SenderKeyStore.dart';

class GroupCipher {
  final SenderKeyStore _senderKeyStore;
  final SenderKeyName _senderKeyId;

  GroupCipher(this._senderKeyStore, this._senderKeyId);

  Future<Uint8List> encrypt(Uint8List paddedPlaintext) async {
    try {
      var record = await _senderKeyStore.loadSenderKey(_senderKeyId);
      print('encrypt _senderKeyId: $_senderKeyId');
      var senderKeyState = record.getSenderKeyState();
      var senderKey = senderKeyState.senderChainKey.senderMessageKey;
      print('cipherKey: ${senderKey.cipherKey}');
      print('iv: ${senderKey.iv}');
      print('paddedPlaintext: $paddedPlaintext');
      var ciphertext =
          aesCbcEncrypt(senderKey.cipherKey, senderKey.iv, paddedPlaintext);
      print('ciphertext: $ciphertext');
      var senderKeyMessage = SenderKeyMessage(senderKeyState.keyId,
          senderKey.iteration, ciphertext, senderKeyState.signingKeyPrivate);
      senderKeyState.senderChainKey = senderKeyState.senderChainKey.next;
      await _senderKeyStore.storeSenderKey(_senderKeyId, record);
      return senderKeyMessage.serialize();
    } on InvalidKeyIdException catch (e) {
      throw NoSessionException(e.detailMessage);
    }
  }

  Future<Uint8List> decrypt(Uint8List senderKeyMessageBytes) async {
    return decryptWithCallback(senderKeyMessageBytes, () {}());
  }

  Future<Uint8List> decryptWithCallback(
      Uint8List senderKeyMessageBytes, DecryptionCallback? callback) async {
    try {
      var record = await _senderKeyStore.loadSenderKey(_senderKeyId);
      print('decryptWithCallback _senderKeyId: ${_senderKeyId.serialize()}');
      if (record.isEmpty) {
        throw NoSessionException('No sender key for: $_senderKeyId');
      }

      var senderKeyMessage =
          SenderKeyMessage.fromSerialized(senderKeyMessageBytes);
      print('senderKeyMessage keyId: ${senderKeyMessage.keyId}, ${senderKeyMessage.ciphertext}');
      var senderKeyState = record.getSenderKeyStateById(senderKeyMessage.keyId);
      senderKeyMessage.verifySignature(senderKeyState.signingKeyPublic);
      var senderKey = getSenderKey(senderKeyState, senderKeyMessage.iteration);
      print('cipherKey: ${senderKey.cipherKey}');
      print('iv: ${senderKey.iv}');
      print('ciphertext: ${senderKeyMessage.ciphertext}');
      var plaintext = aesCbcDecrypt(
          senderKey.cipherKey, senderKey.iv, senderKeyMessage.ciphertext);
      print('plaintext: $plaintext');

      if (callback != null) {
        callback(plaintext);
      }

      await _senderKeyStore.storeSenderKey(_senderKeyId, record);
      return plaintext;
    } on InvalidKeyIdException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  SenderMessageKey getSenderKey(SenderKeyState senderKeyState, int iteration) {
    var senderChainKey = senderKeyState.senderChainKey;
    if (senderChainKey.iteration > iteration) {
      if (senderKeyState.hasSenderMessageKey(iteration)) {
        return senderKeyState.removeSenderMessageKey(iteration)!;
      } else {
        throw DuplicateMessageException('Received message with old counter: '
            '${senderChainKey.iteration} , $iteration');
      }
    }

    if (iteration - senderChainKey.iteration > 2000) {
      throw InvalidMessageException('Over 2000 messages into the future!');
    }

    while (senderChainKey.iteration < iteration) {
      senderKeyState.addSenderMessageKey(senderChainKey.senderMessageKey);
      senderChainKey = senderChainKey.next;
    }

    senderKeyState.senderChainKey = senderChainKey.next;
    return senderChainKey.senderMessageKey;
  }
}

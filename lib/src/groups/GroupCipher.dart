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

  Uint8List encrypt(Uint8List paddedPlaintext) {
    // TODO wrap in synchronized
    try {
      var record = _senderKeyStore.loadSenderKey(_senderKeyId);
      var senderKeyState = record.getSenderKeyState();
      var senderKey = senderKeyState.senderChainKey.senderMessageKey;
      var ciphertext =
          aesCbcEncrypt(senderKey.cipherKey, senderKey.iv, paddedPlaintext);
      var senderKeyMessage = SenderKeyMessage(senderKeyState.keyId,
          senderKey.iteration, ciphertext, senderKeyState.signingKeyPrivate);
      senderKeyState.senderChainKey = senderKeyState.senderChainKey.next;
      _senderKeyStore.storeSenderKey(_senderKeyId, record);
      return senderKeyMessage.serialize();
    } on InvalidKeyIdException catch (e) {
      throw NoSessionException(e.detailMessage);
    }
  }

  Uint8List decrypt(Uint8List senderKeyMessageBytes) {
    return decryptWithCallback(senderKeyMessageBytes, () {}());
  }

  Uint8List decryptWithCallback(
      Uint8List senderKeyMessageBytes, DecryptionCallback callback) {
    // TODO wrap in synchronized
    try {
      var record = _senderKeyStore.loadSenderKey(_senderKeyId);
      if (record.isEmpty) {
        throw NoSessionException('No sender key for: $_senderKeyId');
      }

      var senderKeyMessage =
          SenderKeyMessage.fromSerialized(senderKeyMessageBytes);
      var senderKeyState = record.getSenderKeyStateById(senderKeyMessage.keyId);
      senderKeyMessage.verifySignature(senderKeyState.signingKeyPublic);
      var senderKey = getSenderKey(senderKeyState, senderKeyMessage.iteration);
      var plaintext = aesCbcDecrypt(
          senderKey.cipherKey, senderKey.iv, senderKeyMessage.ciphertext);

      if (callback != null) {
        callback(plaintext);
      }

      _senderKeyStore.storeSenderKey(_senderKeyId, record);
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
        return senderKeyState.removeSenderMessageKey(iteration);
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

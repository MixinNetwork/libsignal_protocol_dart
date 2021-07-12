import 'dart:typed_data';

import '../cbc.dart';
import '../decryption_callback.dart';
import '../duplicate_message_exception.dart';
import '../invalid_key_exception.dart';
import '../invalid_key_id_exception.dart';
import '../invalid_message_exception.dart';
import '../no_session_exception.dart';
import '../protocol/sender_key_message.dart';
import 'ratchet/sender_message_key.dart';
import 'sender_key_name.dart';
import 'state/sender_key_state.dart';
import 'state/sender_key_store.dart';

class GroupCipher {
  GroupCipher(this._senderKeyStore, this._senderKeyId);

  final SenderKeyStore _senderKeyStore;
  final SenderKeyName _senderKeyId;

  Future<Uint8List> encrypt(Uint8List paddedPlaintext) async {
    try {
      final record = await _senderKeyStore.loadSenderKey(_senderKeyId);
      final senderKeyState = record.getSenderKeyState();
      final senderKey = senderKeyState.senderChainKey.senderMessageKey;
      final ciphertext =
          aesCbcEncrypt(senderKey.cipherKey, senderKey.iv, paddedPlaintext);
      final senderKeyMessage = SenderKeyMessage(senderKeyState.keyId,
          senderKey.iteration, ciphertext, senderKeyState.signingKeyPrivate);
      final nextSenderChainKey = senderKeyState.senderChainKey.next;
      senderKeyState.senderChainKey = nextSenderChainKey;
      await _senderKeyStore.storeSenderKey(_senderKeyId, record);
      return senderKeyMessage.serialize();
    } on InvalidKeyIdException catch (e) {
      throw NoSessionException(e.detailMessage);
    }
  }

  Future<Uint8List> decrypt(Uint8List senderKeyMessageBytes) async =>
      decryptWithCallback(senderKeyMessageBytes, () {}());

  Future<Uint8List> decryptWithCallback(
      Uint8List senderKeyMessageBytes, DecryptionCallback? callback) async {
    try {
      final record = await _senderKeyStore.loadSenderKey(_senderKeyId);
      if (record.isEmpty) {
        throw NoSessionException(
            'No group sender key for: ${_senderKeyId.serialize()}');
      }

      final senderKeyMessage =
          SenderKeyMessage.fromSerialized(senderKeyMessageBytes);
      final senderKeyState =
          record.getSenderKeyStateById(senderKeyMessage.keyId);
      senderKeyMessage.verifySignature(senderKeyState.signingKeyPublic);
      final senderKey =
          getSenderKey(senderKeyState, senderKeyMessage.iteration);
      final plaintext = aesCbcDecrypt(
          senderKey.cipherKey, senderKey.iv, senderKeyMessage.ciphertext);

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

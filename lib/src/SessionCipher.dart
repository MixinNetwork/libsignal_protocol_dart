import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/DecryptionCallback.dart';
import 'package:libsignalprotocoldart/src/SessionBuilder.dart';
import 'package:libsignalprotocoldart/src/SignalProtocolAddress.dart';
import 'package:libsignalprotocoldart/src/UntrustedIdentityException.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/protocol/CiphertextMessage.dart';
import 'package:libsignalprotocoldart/src/protocol/PreKeySignalMessage.dart';
import 'package:libsignalprotocoldart/src/protocol/SignalMessage.dart';
import 'package:libsignalprotocoldart/src/ratchet/ChainKey.dart';
import 'package:libsignalprotocoldart/src/ratchet/MessageKeys.dart';
import 'package:libsignalprotocoldart/src/state/IdentityKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/PreKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/SessionRecord.dart';
import 'package:libsignalprotocoldart/src/state/SessionState.dart';
import 'package:libsignalprotocoldart/src/state/SessionStore.dart';
import 'package:libsignalprotocoldart/src/state/SignalProtocolStore.dart';
import 'package:libsignalprotocoldart/src/state/SignedPreKeyStore.dart';

class SessionCipher {
  static final Object SESSION_LOCK = new Object();

  SessionStore _sessionStore;
  IdentityKeyStore _identityKeyStore;
  SessionBuilder _sessionBuilder;
  PreKeyStore _preKeyStore;
  SignalProtocolAddress _remoteAddress;

  SessionCipher(
      this._sessionStore,
      this._preKeyStore,
      SignedPreKeyStore signedPreKeyStore,
      this._identityKeyStore,
      this._remoteAddress) {
    this._sessionBuilder = SessionBuilder(_sessionStore, _preKeyStore,
        signedPreKeyStore, _identityKeyStore, _remoteAddress);
  }

  SessionCipher.fromStore(
      SignalProtocolStore store, SignalProtocolAddress remoteAddress) {
    SessionCipher(store, store, store, store, remoteAddress);
  }

  CiphertextMessage encrypt(Uint8List paddedMessage) {
    synchronized(SESSION_LOCK) {
      SessionRecord sessionRecord = _sessionStore.loadSession(_remoteAddress);
      SessionState sessionState = sessionRecord.getSessionState();
      ChainKey chainKey = sessionState.getSenderChainKey();
      MessageKeys messageKeys = chainKey.getMessageKeys();
      ECPublicKey senderEphemeral = sessionState.getSenderRatchetKey();
      int previousCounter = sessionState.getPreviousCounter();
      int sessionVersion = sessionState.getSessionVersion();

      Uint8List ciphertextBody = getCiphertext(messageKeys, paddedMessage);
      CiphertextMessage ciphertextMessage = new SignalMessage(
          sessionVersion,
          messageKeys.getMacKey(),
          senderEphemeral,
          chainKey.getIndex(),
          previousCounter,
          ciphertextBody,
          sessionState.getLocalIdentityKey(),
          sessionState.getRemoteIdentityKey());

      if (sessionState.hasUnacknowledgedPreKeyMessage()) {
        UnacknowledgedPreKeyMessageItems items =
            sessionState.getUnacknowledgedPreKeyMessageItems();
        int localRegistrationId = sessionState.getLocalRegistrationId();

        ciphertextMessage = PreKeySignalMessage.from(
            sessionVersion,
            localRegistrationId,
            items.getPreKeyId(),
            items.getSignedPreKeyId(),
            items.getBaseKey(),
            sessionState.getLocalIdentityKey(),
            ciphertextMessage as SignalMessage);
      }

      sessionState.setSenderChainKey(chainKey.getNextChainKey());

      if (!_identityKeyStore.isTrustedIdentity(_remoteAddress,
          sessionState.getRemoteIdentityKey(), Direction.SENDING)) {
        throw new UntrustedIdentityException(
            _remoteAddress.getName(), sessionState.getRemoteIdentityKey());
      }

      _identityKeyStore.saveIdentity(
          _remoteAddress, sessionState.getRemoteIdentityKey());
      _sessionStore.storeSession(_remoteAddress, sessionRecord);
      return ciphertextMessage;
    }
  }
/*
    Uint8List getCiphertext(MessageKeys messageKeys, Uint8List plaintext) {
    try {
      Cipher cipher = getCipher(Cipher.ENCRYPT_MODE, messageKeys.getCipherKey(), messageKeys.getIv());
      return cipher.doFinal(plaintext);
    } catch (IllegalBlockSizeException | BadPaddingException e) {
      throw new AssertionError(e);
    }
  }

   Uint8List _getPlaintext(MessageKeys messageKeys, Uint8List cipherText) {
    try {
      Cipher cipher = getCipher(Cipher.DECRYPT_MODE, messageKeys.getCipherKey(), messageKeys.getIv());
      return cipher.doFinal(cipherText);
    } catch (IllegalBlockSizeException | BadPaddingException e) {
      throw new InvalidMessageException(e);
    }
  }

   Cipher _getCipher(int mode, SecretKeySpec key, IvParameterSpec iv) {
    try {
      Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
      cipher.init(mode, key, iv);
      return cipher;
    } catch (NoSuchAlgorithmException | NoSuchPaddingException | java.security.InvalidKeyException |
             InvalidAlgorithmParameterException e)
    {
      throw new AssertionError(e);
    }
    */

}

class NullDecryptionCallback implements DecryptionCallback {
  @override
  void handlePlaintext(Uint8List plaintext) {}
}

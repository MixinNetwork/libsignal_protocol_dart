import 'dart:collection';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'DuplicateMessageException.dart';
import 'InvalidKeyException.dart';
import 'InvalidMessageException.dart';
import 'NoSessionException.dart';
import 'SessionBuilder.dart';
import 'SignalProtocolAddress.dart';
import 'UntrustedIdentityException.dart';
import 'cbc.dart';
import 'ecc/Curve.dart';
import 'DecryptionCallback.dart';
import 'ecc/ECPublicKey.dart';
import 'protocol/CiphertextMessage.dart';
import 'protocol/PreKeySignalMessage.dart';
import 'protocol/SignalMessage.dart';
import 'ratchet/ChainKey.dart';
import 'ratchet/MessageKeys.dart';
import 'state/IdentityKeyStore.dart';
import 'state/PreKeyStore.dart';
import 'state/SessionRecord.dart';
import 'state/SessionState.dart';
import 'state/SessionStore.dart';
import 'state/SignalProtocolStore.dart';
import 'state/SignedPreKeyStore.dart';

class SessionCipher {
  static final Object SESSION_LOCK = Object();

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
    _sessionBuilder = SessionBuilder(_sessionStore, _preKeyStore,
        signedPreKeyStore, _identityKeyStore, _remoteAddress);
  }

  SessionCipher.fromStore(
      SignalProtocolStore store, SignalProtocolAddress remoteAddress) {
    SessionCipher(store, store, store, store, remoteAddress);
  }

  CiphertextMessage encrypt(Uint8List paddedMessage) {
    synchronized(SESSION_LOCK) {
      var sessionRecord = _sessionStore.loadSession(_remoteAddress);
      var sessionState = sessionRecord.sessionState;
      var chainKey = sessionState.getSenderChainKey();
      var messageKeys = chainKey.getMessageKeys();
      var senderEphemeral = sessionState.getSenderRatchetKey();
      var previousCounter = sessionState.previousCounter;
      var sessionVersion = sessionState.getSessionVersion();

      var ciphertextBody = getCiphertext(messageKeys, paddedMessage);
      CiphertextMessage ciphertextMessage = SignalMessage(
          sessionVersion,
          messageKeys.getMacKey(),
          senderEphemeral,
          chainKey.getIndex(),
          previousCounter,
          ciphertextBody,
          sessionState.getLocalIdentityKey(),
          sessionState.getRemoteIdentityKey());

      if (sessionState.hasUnacknowledgedPreKeyMessage()) {
        var items = sessionState.getUnacknowledgedPreKeyMessageItems();
        var localRegistrationId = sessionState.localRegistrationId;

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
        throw UntrustedIdentityException(
            _remoteAddress.getName(), sessionState.getRemoteIdentityKey());
      }

      _identityKeyStore.saveIdentity(
          _remoteAddress, sessionState.getRemoteIdentityKey());
      _sessionStore.storeSession(_remoteAddress, sessionRecord);
      return ciphertextMessage;
    }
  }

  Uint8List decrypt(PreKeySignalMessage ciphertext) {
    return decryptWithCallback(ciphertext, NullDecryptionCallback());
  }

  Uint8List decryptWithCallback(
      PreKeySignalMessage ciphertext, DecryptionCallback callback) {
    synchronized(SESSION_LOCK) {
      var sessionRecord = _sessionStore.loadSession(_remoteAddress);
      var unsignedPreKeyId = _sessionBuilder.process(sessionRecord, ciphertext);
      var plaintext = _decrypt(sessionRecord, ciphertext.getWhisperMessage());

      callback.handlePlaintext(plaintext);

      _sessionStore.storeSession(_remoteAddress, sessionRecord);

      if (unsignedPreKeyId.isPresent) {
        _preKeyStore.removePreKey(unsignedPreKeyId.value);
      }

      return plaintext;
    }
  }

  Uint8List decryptFromSignal(SignalMessage cipherText) {
    return decryptFromSignalWithCallback(cipherText, NullDecryptionCallback());
  }

  Uint8List decryptFromSignalWithCallback(
      SignalMessage cipherText, DecryptionCallback callback) {
    synchronized(SESSION_LOCK) {
      if (!_sessionStore.containsSession(_remoteAddress)) {
        throw NoSessionException('No session for: $_remoteAddress');
      }

      var sessionRecord = _sessionStore.loadSession(_remoteAddress);
      var plaintext = _decrypt(sessionRecord, cipherText);

      if (!_identityKeyStore.isTrustedIdentity(
          _remoteAddress,
          sessionRecord.sessionState.getRemoteIdentityKey(),
          Direction.RECEIVING)) {
        throw UntrustedIdentityException(_remoteAddress.getName(),
            sessionRecord.sessionState.getRemoteIdentityKey());
      }

      _identityKeyStore.saveIdentity(
          _remoteAddress, sessionRecord.sessionState.getRemoteIdentityKey());

      callback.handlePlaintext(plaintext);

      _sessionStore.storeSession(_remoteAddress, sessionRecord);

      return plaintext;
    }
  }

  Uint8List _decrypt(SessionRecord sessionRecord, SignalMessage cipherText) {
    synchronized(SESSION_LOCK) {
      var previousStates = sessionRecord.previousSessionStates.iterator;
      var exceptions = [];

      try {
        var sessionState =
            SessionState.fromSessionState(sessionRecord.sessionState);
        var plaintext = _decryptFromState(sessionState, cipherText);

        sessionRecord.setState(sessionState);
        return plaintext;
      } on InvalidMessageException catch (e) {
        exceptions.add(e);
      }
      var _previousStates = HasNextIterator(previousStates);
      while (_previousStates.hasNext) {
        try {
          var promotedState =
              SessionState.fromSessionState(_previousStates.next());
          var plaintext = _decryptFromState(promotedState, cipherText);

          // _previousStates.remove();
          sessionRecord.promoteState(promotedState);

          return plaintext;
        } on InvalidMessageException catch (e) {
          exceptions.add(e);
        }
      }

      throw InvalidMessageException('No valid sessions. $exceptions[0]');
    }
  }

  Uint8List _decryptFromState(
      SessionState sessionState, SignalMessage ciphertextMessage) {
    if (!sessionState.hasSenderChain()) {
      throw InvalidMessageException('Uninitialized session!');
    }

    if (ciphertextMessage.getMessageVersion() !=
        sessionState.getSessionVersion()) {
      throw InvalidMessageException(
          'Message version $ciphertextMessage.getMessageVersion(), but session version $sessionState.getSessionVersion()');
    }

    var theirEphemeral = ciphertextMessage.getSenderRatchetKey();
    var counter = ciphertextMessage.getCounter();
    var chainKey = _getOrCreateChainKey(sessionState, theirEphemeral);
    var messageKeys = _getOrCreateMessageKeys(
        sessionState, theirEphemeral, chainKey, counter);

    ciphertextMessage.verifyMac(sessionState.getRemoteIdentityKey(),
        sessionState.getLocalIdentityKey(), messageKeys.getMacKey());

    var plaintext = _getPlaintext(messageKeys, ciphertextMessage.getBody());

    sessionState.clearUnacknowledgedPreKeyMessage();

    return plaintext;
  }

  int getRemoteRegistrationId() {
    synchronized(SESSION_LOCK) {
      var record = _sessionStore.loadSession(_remoteAddress);
      return record.sessionState.remoteRegistrationId;
    }
  }

  int getSessionVersion() {
    synchronized(SESSION_LOCK) {
      if (!_sessionStore.containsSession(_remoteAddress)) {
        // throw IllegalStateException("No session for ($_remoteAddress)!");
      }

      var record = _sessionStore.loadSession(_remoteAddress);
      return record.sessionState.getSessionVersion();
    }
  }

  ChainKey _getOrCreateChainKey(
      SessionState sessionState, ECPublicKey theirEphemeral) {
    try {
      if (sessionState.hasReceiverChain(theirEphemeral)) {
        return sessionState.getReceiverChainKey(theirEphemeral);
      } else {
        var rootKey = sessionState.getRootKey();
        var ourEphemeral = sessionState.getSenderRatchetKeyPair();
        var receiverChain = rootKey.createChain(theirEphemeral, ourEphemeral);
        var ourNewEphemeral = Curve.generateKeyPair();
        var senderChain =
            receiverChain.item1.createChain(theirEphemeral, ourNewEphemeral);

        sessionState.rootKey = senderChain.item1;
        sessionState.addReceiverChain(theirEphemeral, receiverChain.item2);
        sessionState.previousCounter =
            max(sessionState.getSenderChainKey().getIndex() - 1, 0);
        sessionState.setSenderChain(ourNewEphemeral, senderChain.item2);

        return receiverChain.item2;
      }
    } on InvalidKeyException {
      rethrow;
    }
  }

  MessageKeys _getOrCreateMessageKeys(SessionState sessionState,
      ECPublicKey theirEphemeral, ChainKey chainKey, int counter) {
    if (chainKey.getIndex() > counter) {
      if (sessionState.hasMessageKeys(theirEphemeral, counter)) {
        return sessionState.removeMessageKeys(theirEphemeral, counter);
      } else {
        throw DuplicateMessageException(
            'Received message with old counter: $chainKey.getIndex(), $counter');
      }
    }

    if (counter - chainKey.getIndex() > 2000) {
      throw InvalidMessageException('Over 2000 messages into the future!');
    }

    while (chainKey.getIndex() < counter) {
      var messageKeys = chainKey.getMessageKeys();
      sessionState.setMessageKeys(theirEphemeral, messageKeys);
      chainKey = chainKey.getNextChainKey();
    }

    sessionState.setReceiverChainKey(
        theirEphemeral, chainKey.getNextChainKey());
    return chainKey.getMessageKeys();
  }

  Uint8List getCiphertext(MessageKeys messageKeys, Uint8List plaintext) {
    return aesCbcEncrypt(
        messageKeys.getCipherKey(), messageKeys.getIv(), plaintext);
  }

  Uint8List _getPlaintext(MessageKeys messageKeys, Uint8List cipherText) {
    return aesCbcDecrypt(
        messageKeys.getCipherKey(), messageKeys.getIv(), cipherText);
  }
}

class NullDecryptionCallback implements DecryptionCallback {
  @override
  void handlePlaintext(Uint8List plaintext) {}
}

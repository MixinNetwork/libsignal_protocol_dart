import 'dart:collection';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'cbc.dart';
import 'decryption_callback.dart';
import 'duplicate_message_exception.dart';
import 'ecc/curve.dart';
import 'ecc/ec_public_key.dart';
import 'invalid_key_exception.dart';
import 'invalid_message_exception.dart';
import 'no_session_exception.dart';
import 'protocol/ciphertext_message.dart';
import 'protocol/pre_key_signal_message.dart';
import 'protocol/signal_message.dart';
import 'ratchet/chain_key.dart';
import 'ratchet/message_keys.dart';
import 'session_builder.dart';
import 'signal_protocol_address.dart';
import 'state/identity_key_store.dart';
import 'state/pre_key_store.dart';
import 'state/session_record.dart';
import 'state/session_state.dart';
import 'state/session_store.dart';
import 'state/signal_protocol_store.dart';
import 'state/signed_pre_key_store.dart';
import 'untrusted_identity_exception.dart';

class SessionCipher {
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
      SignalProtocolStore store, SignalProtocolAddress remoteAddress)
      : this(store, store, store, store, remoteAddress);

  static final Object sessionLock = Object();

  SessionStore _sessionStore;
  IdentityKeyStore _identityKeyStore;
  late SessionBuilder _sessionBuilder;
  PreKeyStore _preKeyStore;
  SignalProtocolAddress _remoteAddress;

  Future<CiphertextMessage> encrypt(Uint8List paddedMessage) async {
    final sessionRecord = await _sessionStore.loadSession(_remoteAddress);
    final sessionState = sessionRecord.sessionState;
    final chainKey = sessionState.getSenderChainKey();
    final messageKeys = chainKey.getMessageKeys();
    final senderEphemeral = sessionState.getSenderRatchetKey();
    final previousCounter = sessionState.previousCounter;
    final sessionVersion = sessionState.getSessionVersion();

    final ciphertextBody = getCiphertext(messageKeys, paddedMessage);
    CiphertextMessage ciphertextMessage = SignalMessage(
        sessionVersion,
        messageKeys.getMacKey(),
        senderEphemeral,
        chainKey.index,
        previousCounter,
        ciphertextBody,
        sessionState.getLocalIdentityKey(),
        sessionState.getRemoteIdentityKey());
    if (sessionState.hasUnacknowledgedPreKeyMessage()) {
      final items = sessionState.getUnacknowledgedPreKeyMessageItems();
      final localRegistrationId = sessionState.localRegistrationId;

      ciphertextMessage = PreKeySignalMessage.from(
          sessionVersion,
          localRegistrationId,
          items.getPreKeyId(),
          items.getSignedPreKeyId(),
          items.getBaseKey(),
          sessionState.getLocalIdentityKey(),
          ciphertextMessage as SignalMessage);
    }

    final nextChainKey = chainKey.getNextChainKey();
    sessionState.setSenderChainKey(nextChainKey);

    if (!await _identityKeyStore.isTrustedIdentity(_remoteAddress,
        sessionState.getRemoteIdentityKey(), Direction.sending)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), sessionState.getRemoteIdentityKey());
    }

    await _identityKeyStore.saveIdentity(
        _remoteAddress, sessionState.getRemoteIdentityKey());
    await _sessionStore.storeSession(_remoteAddress, sessionRecord);
    return ciphertextMessage;
  }

  Future<Uint8List> decrypt(PreKeySignalMessage ciphertext) async =>
      decryptWithCallback(ciphertext, () {}());

  Future<Uint8List> decryptWithCallback(
      PreKeySignalMessage ciphertext, DecryptionCallback? callback) async {
    final sessionRecord = await _sessionStore.loadSession(_remoteAddress);
    final unsignedPreKeyId =
        await _sessionBuilder.process(sessionRecord, ciphertext);
    final plaintext = _decrypt(sessionRecord, ciphertext.getWhisperMessage());

    if (callback != null) {
      callback(plaintext);
    }

    await _sessionStore.storeSession(_remoteAddress, sessionRecord);

    if (unsignedPreKeyId.isPresent) {
      await _preKeyStore.removePreKey(unsignedPreKeyId.value);
    }

    return plaintext;
  }

  Future<Uint8List> decryptFromSignal(SignalMessage cipherText) async =>
      decryptFromSignalWithCallback(cipherText, () {}());

  Future<Uint8List> decryptFromSignalWithCallback(
      SignalMessage cipherText, DecryptionCallback? callback) async {
    if (!await _sessionStore.containsSession(_remoteAddress)) {
      throw NoSessionException('No session for: $_remoteAddress');
    }

    final sessionRecord = await _sessionStore.loadSession(_remoteAddress);
    final plaintext = _decrypt(sessionRecord, cipherText);

    if (!await _identityKeyStore.isTrustedIdentity(
        _remoteAddress,
        sessionRecord.sessionState.getRemoteIdentityKey(),
        Direction.receiving)) {
      throw UntrustedIdentityException(_remoteAddress.getName(),
          sessionRecord.sessionState.getRemoteIdentityKey());
    }

    await _identityKeyStore.saveIdentity(
        _remoteAddress, sessionRecord.sessionState.getRemoteIdentityKey());

    if (callback != null) {
      callback(plaintext);
    }

    await _sessionStore.storeSession(_remoteAddress, sessionRecord);

    return plaintext;
  }

  Uint8List _decrypt(SessionRecord sessionRecord, SignalMessage cipherText) {
    final previousStates = sessionRecord.previousSessionStates;
    final exceptions = <Exception>[];

    try {
      final sessionState =
          SessionState.fromSessionState(sessionRecord.sessionState);
      final plaintext = _decryptFromState(sessionState, cipherText);

      sessionRecord.state = sessionState;
      return plaintext;
    } on InvalidMessageException catch (e) {
      exceptions.add(e);
    }
    final _previousStates = HasNextIterator(previousStates.iterator);
    while (_previousStates.hasNext) {
      try {
        final promotedState =
            SessionState.fromSessionState(_previousStates.next());
        final plaintext = _decryptFromState(promotedState, cipherText);

        previousStates.remove(promotedState);
        sessionRecord.promoteState(promotedState);

        return plaintext;
      } on InvalidMessageException catch (e) {
        exceptions.add(e);
      }
    }

    throw InvalidMessageException('No valid sessions. $exceptions[0]');
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

    final theirEphemeral = ciphertextMessage.getSenderRatchetKey();
    final counter = ciphertextMessage.getCounter();
    final chainKey = _getOrCreateChainKey(sessionState, theirEphemeral);
    final messageKeys = _getOrCreateMessageKeys(
        sessionState, theirEphemeral, chainKey!, counter);

    ciphertextMessage.verifyMac(sessionState.getRemoteIdentityKey()!,
        sessionState.getLocalIdentityKey(), messageKeys!.getMacKey());

    final plaintext = _getPlaintext(messageKeys, ciphertextMessage.getBody());

    sessionState.clearUnacknowledgedPreKeyMessage();

    return plaintext;
  }

  Future<int> getRemoteRegistrationId() async {
    final record = await _sessionStore.loadSession(_remoteAddress);
    return record.sessionState.remoteRegistrationId;
  }

  Future<int> getSessionVersion() async {
    if (!await _sessionStore.containsSession(_remoteAddress)) {
      // throw IllegalStateException("No session for ($_remoteAddress)!");
    }

    final record = await _sessionStore.loadSession(_remoteAddress);
    return record.sessionState.getSessionVersion();
  }

  ChainKey? _getOrCreateChainKey(
      SessionState sessionState, ECPublicKey theirEphemeral) {
    try {
      if (sessionState.hasReceiverChain(theirEphemeral)) {
        return sessionState.getReceiverChainKey(theirEphemeral);
      } else {
        final rootKey = sessionState.getRootKey();
        final ourEphemeral = sessionState.getSenderRatchetKeyPair();
        final receiverChain = rootKey.createChain(theirEphemeral, ourEphemeral);
        final ourNewEphemeral = Curve.generateKeyPair();
        final senderChain =
            receiverChain.item1.createChain(theirEphemeral, ourNewEphemeral);

        sessionState
          ..rootKey = senderChain.item1
          ..addReceiverChain(theirEphemeral, receiverChain.item2)
          ..previousCounter = max(sessionState.getSenderChainKey().index - 1, 0)
          ..setSenderChain(ourNewEphemeral, senderChain.item2);

        return receiverChain.item2;
      }
    } on InvalidKeyException {
      rethrow;
    }
  }

  MessageKeys? _getOrCreateMessageKeys(SessionState sessionState,
      ECPublicKey theirEphemeral, ChainKey chainKey, int counter) {
    if (chainKey.index > counter) {
      if (sessionState.hasMessageKeys(theirEphemeral, counter)) {
        return sessionState.removeMessageKeys(theirEphemeral, counter);
      } else {
        throw DuplicateMessageException(
            'Received message with old counter: ${chainKey.index}, $counter');
      }
    }

    if (counter - chainKey.index > 2000) {
      throw InvalidMessageException('Over 2000 messages into the future!');
    }

    while (chainKey.index < counter) {
      final messageKeys = chainKey.getMessageKeys();
      sessionState.setMessageKeys(theirEphemeral, messageKeys);
      // ignore: parameter_assignments
      chainKey = chainKey.getNextChainKey();
    }

    sessionState.setReceiverChainKey(
        theirEphemeral, chainKey.getNextChainKey());
    return chainKey.getMessageKeys();
  }

  Uint8List getCiphertext(MessageKeys messageKeys, Uint8List plaintext) =>
      aesCbcEncrypt(messageKeys.getCipherKey(), messageKeys.getIv(), plaintext);

  Uint8List _getPlaintext(MessageKeys messageKeys, Uint8List cipherText) =>
      aesCbcDecrypt(
          messageKeys.getCipherKey(), messageKeys.getIv(), cipherText);
}

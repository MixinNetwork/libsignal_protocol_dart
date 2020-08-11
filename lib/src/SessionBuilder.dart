import 'dart:convert';
import 'dart:typed_data';

import 'InvalidKeyException.dart';
import 'SignalProtocolAddress.dart';
import 'UntrustedIdentityException.dart';
import 'ecc/Curve.dart';
import 'ecc/ECKeyPair.dart';
import 'protocol/PreKeySignalMessage.dart';
import 'ratchet/AliceSignalProtocolParameters.dart';
import 'ratchet/BobSignalProtocolParameters.dart';
import 'ratchet/RatchetingSession.dart';
import 'state/IdentityKeyStore.dart';
import 'state/PreKeyBundle.dart';
import 'state/PreKeyStore.dart';
import 'state/SessionRecord.dart';
import 'state/SessionStore.dart';
import 'state/SignalProtocolStore.dart';
import 'state/SignedPreKeyStore.dart';

import 'package:optional/optional.dart';

class SessionBuilder {
  static final String TAG = 'SessionBulder';

  SessionStore _sessionStore;
  PreKeyStore _preKeyStore;
  SignedPreKeyStore _signedPreKeyStore;
  IdentityKeyStore _identityKeyStore;
  SignalProtocolAddress _remoteAddress;

  SessionBuilder(this._sessionStore, this._preKeyStore, this._signedPreKeyStore,
      this._identityKeyStore, this._remoteAddress);

  SessionBuilder.fromSignalStore(
      SignalProtocolStore store, SignalProtocolAddress remoteAddress)
      : this(store, store, store, store, remoteAddress);

  Optional<int> process(
      SessionRecord sessionRecord, PreKeySignalMessage message) {
    var theirIdentityKey = message.getIdentityKey();

    if (!_identityKeyStore.isTrustedIdentity(
        _remoteAddress, theirIdentityKey, Direction.RECEIVING)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), theirIdentityKey);
    }

    var unsignedPreKeyId = processV3(sessionRecord, message);

    _identityKeyStore.saveIdentity(_remoteAddress, theirIdentityKey);

    return unsignedPreKeyId;
  }

  Optional<int> processV3(
      SessionRecord sessionRecord, PreKeySignalMessage message) {
    if (sessionRecord.hasSessionState(
        message.getMessageVersion(), message.getBaseKey().serialize())) {
      print(
          "We've already setup a session for this V3 message, letting bundled message fall through...");
      return Optional.empty();
    }

    var ourSignedPreKey = _signedPreKeyStore
        .loadSignedPreKey(message.getSignedPreKeyId())
        .getKeyPair();

    var parameters = BobSignalProtocolParameters.newBuilder();

    parameters
        .setTheirBaseKey(message.getBaseKey())
        .setTheirIdentityKey(message.getIdentityKey())
        .setOurIdentityKey(_identityKeyStore.getIdentityKeyPair())
        .setOurSignedPreKey(ourSignedPreKey)
        .setOurRatchetKey(ourSignedPreKey);

    if (message.getPreKeyId().isPresent) {
      parameters.setOurOneTimePreKey(Optional.of(
          _preKeyStore.loadPreKey(message.getPreKeyId().value).getKeyPair()));
    } else {
      parameters.setOurOneTimePreKey(Optional<ECKeyPair>.empty());
    }

    if (!sessionRecord.isFresh()) sessionRecord.archiveCurrentState();

    RatchetingSession.initializeSessionBob(
        sessionRecord.sessionState, parameters.create());

    sessionRecord.sessionState.localRegistrationId =
        _identityKeyStore.getLocalRegistrationId();
    sessionRecord.sessionState.remoteRegistrationId =
        message.getRegistrationId();
    sessionRecord.sessionState.aliceBaseKey = message.getBaseKey().serialize();

    if (message.getPreKeyId().isPresent) {
      return message.getPreKeyId();
    } else {
      return Optional.empty();
    }
  }

  void processPreKeyBundle(PreKeyBundle preKey) {
    //synchronized (SessionCipher.SESSION_LOCK) {
    if (!_identityKeyStore.isTrustedIdentity(
        _remoteAddress, preKey.getIdentityKey(), Direction.SENDING)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), preKey.getIdentityKey());
    }

    if (preKey.getSignedPreKey() != null &&
        !Curve.verifySignature(
            preKey.getIdentityKey().publicKey,
            preKey.getSignedPreKey().serialize(),
            preKey.getSignedPreKeySignature())) {
      throw InvalidKeyException('Invalid signature on device key!');
    }

    if (preKey.getSignedPreKey() == null) {
      throw InvalidKeyException('No signed prekey!');
    }

    var sessionRecord = _sessionStore.loadSession(_remoteAddress);
    var ourBaseKey = Curve.generateKeyPair();
    var theirSignedPreKey = preKey.getSignedPreKey();
    var theirOneTimePreKey = Optional.ofNullable(preKey.getPreKey());
    var theirOneTimePreKeyId = theirOneTimePreKey.isPresent
        ? Optional.of(preKey.getPreKeyId())
        : Optional<int>.empty();

    var parameters = AliceSignalProtocolParameters.newBuilder();

    parameters
        .setOurBaseKey(ourBaseKey)
        .setOurIdentityKey(_identityKeyStore.getIdentityKeyPair())
        .setTheirIdentityKey(preKey.getIdentityKey())
        .setTheirSignedPreKey(theirSignedPreKey)
        .setTheirRatchetKey(theirSignedPreKey)
        .setTheirOneTimePreKey(theirOneTimePreKey);

    if (!sessionRecord.isFresh()) sessionRecord.archiveCurrentState();

    RatchetingSession.initializeSessionAlice(
        sessionRecord.sessionState, parameters.create());

    sessionRecord.sessionState.setUnacknowledgedPreKeyMessage(
        theirOneTimePreKeyId, preKey.getSignedPreKeyId(), ourBaseKey.publicKey);
    sessionRecord.sessionState.localRegistrationId =
        _identityKeyStore.getLocalRegistrationId();
    sessionRecord.sessionState.remoteRegistrationId =
        preKey.getRegistrationId();
    sessionRecord.sessionState.aliceBaseKey = ourBaseKey.publicKey.serialize();

    _identityKeyStore.saveIdentity(_remoteAddress, preKey.getIdentityKey());
    _sessionStore.storeSession(_remoteAddress, sessionRecord);
    //}
  }
}

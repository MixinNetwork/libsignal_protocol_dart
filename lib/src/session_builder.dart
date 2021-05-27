import 'package:optional/optional.dart';

import 'ecc/curve.dart';
import 'ecc/ec_key_pair.dart';
import 'invalid_key_exception.dart';
import 'protocol/pre_key_signal_message.dart';
import 'ratchet/alice_signal_protocol_parameters.dart';
import 'ratchet/bob_signal_protocol_parameters.dart';
import 'ratchet/ratcheting_session.dart';
import 'signal_protocol_address.dart';
import 'state/identity_key_store.dart';
import 'state/pre_key_bundle.dart';
import 'state/pre_key_store.dart';
import 'state/session_record.dart';
import 'state/session_store.dart';
import 'state/signal_protocol_store.dart';
import 'state/signed_pre_key_store.dart';
import 'untrusted_identity_exception.dart';

class SessionBuilder {
  SessionBuilder(this._sessionStore, this._preKeyStore, this._signedPreKeyStore,
      this._identityKeyStore, this._remoteAddress);

  SessionBuilder.fromSignalStore(
      SignalProtocolStore store, SignalProtocolAddress remoteAddress)
      : this(store, store, store, store, remoteAddress);

  static const String TAG = 'SessionBuilder';

  SessionStore _sessionStore;
  PreKeyStore _preKeyStore;
  SignedPreKeyStore _signedPreKeyStore;
  IdentityKeyStore _identityKeyStore;
  SignalProtocolAddress _remoteAddress;

  Future<Optional<int>> process(
      SessionRecord sessionRecord, PreKeySignalMessage message) async {
    final theirIdentityKey = message.getIdentityKey();

    if (!await _identityKeyStore.isTrustedIdentity(
        _remoteAddress, theirIdentityKey, Direction.RECEIVING)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), theirIdentityKey);
    }

    final unsignedPreKeyId = processV3(sessionRecord, message);

    await _identityKeyStore.saveIdentity(_remoteAddress, theirIdentityKey);

    return unsignedPreKeyId;
  }

  Future<Optional<int>> processV3(
      SessionRecord sessionRecord, PreKeySignalMessage message) async {
    if (sessionRecord.hasSessionState(
        message.getMessageVersion(), message.getBaseKey().serialize())) {
      print(
          "We've already setup a session for this V3 message, letting bundled message fall through...");
      return const Optional.empty();
    }

    final ourSignedPreKey = _signedPreKeyStore
        .loadSignedPreKey(message.getSignedPreKeyId())
        .then((value) => value.getKeyPair());

    final parameters = BobSignalProtocolParameters.newBuilder();

    parameters
        .setTheirBaseKey(message.getBaseKey())
        .setTheirIdentityKey(message.getIdentityKey())
        .setOurIdentityKey(await _identityKeyStore.getIdentityKeyPair())
        .setOurSignedPreKey(await ourSignedPreKey)
        .setOurRatchetKey(await ourSignedPreKey);

    if (message.getPreKeyId().isPresent) {
      parameters.setOurOneTimePreKey(Optional.of(await _preKeyStore
          .loadPreKey(message.getPreKeyId().value)
          .then((value) => value.getKeyPair())));
    } else {
      parameters.setOurOneTimePreKey(const Optional<ECKeyPair>.empty());
    }

    if (!sessionRecord.isFresh()) sessionRecord.archiveCurrentState();

    RatchetingSession.initializeSessionBob(
        sessionRecord.sessionState, parameters.create());

    sessionRecord.sessionState.localRegistrationId =
        await _identityKeyStore.getLocalRegistrationId();
    sessionRecord.sessionState.remoteRegistrationId =
        message.getRegistrationId();
    sessionRecord.sessionState.aliceBaseKey = message.getBaseKey().serialize();

    if (message.getPreKeyId().isPresent) {
      return message.getPreKeyId();
    } else {
      return const Optional.empty();
    }
  }

  Future<void> processPreKeyBundle(PreKeyBundle preKey) async {
    if (!await _identityKeyStore.isTrustedIdentity(
        _remoteAddress, preKey.getIdentityKey(), Direction.SENDING)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), preKey.getIdentityKey());
    }

    if (preKey.getSignedPreKey() != null &&
        !Curve.verifySignature(
            preKey.getIdentityKey().publicKey,
            preKey.getSignedPreKey()!.serialize(),
            preKey.getSignedPreKeySignature())) {
      throw InvalidKeyException('Invalid signature on device key!');
    }

    if (preKey.getSignedPreKey() == null) {
      throw InvalidKeyException('No signed prekey!');
    }

    final sessionRecord = await _sessionStore.loadSession(_remoteAddress);
    final ourBaseKey = Curve.generateKeyPair();
    final theirSignedPreKey = preKey.getSignedPreKey();
    final theirOneTimePreKey = Optional.ofNullable(preKey.getPreKey());
    final theirOneTimePreKeyId = theirOneTimePreKey.isPresent
        ? Optional.of(preKey.getPreKeyId())
        : const Optional<int>.empty();

    final parameters = AliceSignalProtocolParameters.newBuilder();
    parameters
        .setOurBaseKey(ourBaseKey)
        .setOurIdentityKey(await _identityKeyStore.getIdentityKeyPair())
        .setTheirIdentityKey(preKey.getIdentityKey())
        .setTheirSignedPreKey(theirSignedPreKey!)
        .setTheirRatchetKey(theirSignedPreKey)
        .setTheirOneTimePreKey(theirOneTimePreKey);

    if (!sessionRecord.isFresh()) sessionRecord.archiveCurrentState();

    RatchetingSession.initializeSessionAlice(
        sessionRecord.sessionState, parameters.create());

    sessionRecord.sessionState.setUnacknowledgedPreKeyMessage(
        theirOneTimePreKeyId, preKey.getSignedPreKeyId(), ourBaseKey.publicKey);
    sessionRecord.sessionState.localRegistrationId =
        await _identityKeyStore.getLocalRegistrationId();
    sessionRecord.sessionState.remoteRegistrationId =
        preKey.getRegistrationId();
    sessionRecord.sessionState.aliceBaseKey = ourBaseKey.publicKey.serialize();

    await _identityKeyStore.saveIdentity(
        _remoteAddress, preKey.getIdentityKey());
    await _sessionStore.storeSession(_remoteAddress, sessionRecord);
  }
}

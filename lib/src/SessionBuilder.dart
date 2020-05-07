import 'package:libsignalprotocoldart/src/InvalidKeyException.dart';
import 'package:libsignalprotocoldart/src/SignalProtocolAddress.dart';
import 'package:libsignalprotocoldart/src/UntrustedIdentityException.dart';
import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/protocol/PreKeySignalMessage.dart';
import 'package:libsignalprotocoldart/src/ratchet/AliceSignalProtocolParameters.dart';
import 'package:libsignalprotocoldart/src/ratchet/BobSignalProtocolParameters.dart';
import 'package:libsignalprotocoldart/src/ratchet/RatchetingSession.dart';
import 'package:libsignalprotocoldart/src/state/IdentityKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/PreKeyBundle.dart';
import 'package:libsignalprotocoldart/src/state/PreKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/SessionRecord.dart';
import 'package:libsignalprotocoldart/src/state/SessionStore.dart';
import 'package:libsignalprotocoldart/src/state/SignalProtocolStore.dart';
import 'package:libsignalprotocoldart/src/state/SignedPreKeyStore.dart';

import 'package:optional/optional.dart';

class SessionBuilder {
  static final String TAG = 'SessionBulder';

  SessionStore _sessionStore;
  PreKeyStore _preKeyStore;
  SignedPreKeyStore _signedPreKeyStore;
  IdentityKeyStore _identityKeyStore;
  SignalProtocolAddress _remoteAddress;

  SessionBuilder(
      SessionStore sessionStore,
      PreKeyStore preKeyStore,
      SignedPreKeyStore signedPreKeyStore,
      IdentityKeyStore identityKeyStore,
      SignalProtocolAddress remoteAddress) {
    this._sessionStore = sessionStore;
    this._preKeyStore = preKeyStore;
    this._signedPreKeyStore = signedPreKeyStore;
    this._identityKeyStore = identityKeyStore;
    this._remoteAddress = remoteAddress;
  }

  SessionBuilder.fromSignalStore(
      SignalProtocolStore store, SignalProtocolAddress remoteAddress) {
    SessionBuilder(store, store, store, store, remoteAddress);
  }

  Optional<int> process(
      SessionRecord sessionRecord, PreKeySignalMessage message) {
    var theirIdentityKey = message.getIdentityKey();

    if (!_identityKeyStore.isTrustedIdentity(
        _remoteAddress, theirIdentityKey, Direction.RECEIVING)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), theirIdentityKey);
    }

    Optional<int> unsignedPreKeyId = processV3(sessionRecord, message);

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
        sessionRecord.getSessionState(), parameters.create());

    sessionRecord
        .getSessionState()
        .setLocalRegistrationId(_identityKeyStore.getLocalRegistrationId());
    sessionRecord
        .getSessionState()
        .setRemoteRegistrationId(message.getRegistrationId());
    sessionRecord
        .getSessionState()
        .setAliceBaseKey(message.getBaseKey().serialize());

    if (message.getPreKeyId().isPresent) {
      return message.getPreKeyId();
    } else {
      return Optional.empty();
    }
  }

  void processPreKeyBundle(PreKeyBundle preKey) {
    // synchronized (SessionCipher.SESSION_LOCK) {
    if (!_identityKeyStore.isTrustedIdentity(
        _remoteAddress, preKey.getIdentityKey(), Direction.SENDING)) {
      throw UntrustedIdentityException(
          _remoteAddress.getName(), preKey.getIdentityKey());
    }

    if (preKey.getSignedPreKey() != null &&
        !Curve.verifySignature(
            preKey.getIdentityKey().getPublicKey(),
            preKey.getSignedPreKey().serialize(),
            preKey.getSignedPreKeySignature())) {
      throw InvalidKeyException("Invalid signature on device key!");
    }

    if (preKey.getSignedPreKey() == null) {
      throw InvalidKeyException("No signed prekey!");
    }

    SessionRecord sessionRecord = _sessionStore.loadSession(_remoteAddress);
    ECKeyPair ourBaseKey = Curve.generateKeyPair();
    ECPublicKey theirSignedPreKey = preKey.getSignedPreKey();
    Optional<ECPublicKey> theirOneTimePreKey =
        Optional.ofNullable(preKey.getPreKey());
    Optional<int> theirOneTimePreKeyId = theirOneTimePreKey.isPresent
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
        sessionRecord.getSessionState(), parameters.create());

    sessionRecord.getSessionState().setUnacknowledgedPreKeyMessage(
        theirOneTimePreKeyId,
        preKey.getSignedPreKeyId(),
        ourBaseKey.getPublicKey());
    sessionRecord
        .getSessionState()
        .setLocalRegistrationId(_identityKeyStore.getLocalRegistrationId());
    sessionRecord
        .getSessionState()
        .setRemoteRegistrationId(preKey.getRegistrationId());
    sessionRecord
        .getSessionState()
        .setAliceBaseKey(ourBaseKey.getPublicKey().serialize());

    _identityKeyStore.saveIdentity(_remoteAddress, preKey.getIdentityKey());
    _sessionStore.storeSession(_remoteAddress, sessionRecord);
    // }
  }
}

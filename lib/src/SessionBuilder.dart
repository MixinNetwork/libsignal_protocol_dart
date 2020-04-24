import 'package:libsignalprotocoldart/src/SignalProtocolAddress.dart';
import 'package:libsignalprotocoldart/src/protocol/PreKeySignalMessage.dart';
import 'package:libsignalprotocoldart/src/ratchet/BobSignalProtocolParameters.dart';
import 'package:libsignalprotocoldart/src/state/IdentityKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/PreKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/SessionRecord.dart';
import 'package:libsignalprotocoldart/src/state/SessionStore.dart';
import 'package:libsignalprotocoldart/src/state/SignalProtocolStore.dart';
import 'package:libsignalprotocoldart/src/state/SignedPreKeyStore.dart';

import 'package:optional/optional.dart';

class SessionBuilder {
  static final String TAG = "SessionBulder";

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
      SessionRecord sessionRecord, PreKeySignalMessage message)
  //     throws InvalidKeyIdException, InvalidKeyException, UntrustedIdentityException
  {
    var theirIdentityKey = message.getIdentityKey();

    if (!_identityKeyStore.isTrustedIdentity(
        _remoteAddress, theirIdentityKey, Direction.RECEIVING)) {
      // throw new UntrustedIdentityException(
      //     remoteAddress.getName(), theirIdentityKey);
    }

    Optional<int> unsignedPreKeyId = processV3(sessionRecord, message);

    _identityKeyStore.saveIdentity(_remoteAddress, theirIdentityKey);

    return unsignedPreKeyId;
  }

  Optional<int> processV3(
      SessionRecord sessionRecord, PreKeySignalMessage message)
  // throws UntrustedIdentityException, InvalidKeyIdException, InvalidKeyException
  {
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

/*
    if (message.getPreKeyId().isPresent()) {
      parameters.setOurOneTimePreKey(Optional.of(_preKeyStore.loadPreKey(message.getPreKeyId().get()).getKeyPair()));
    } else {
      parameters.setOurOneTimePreKey(Optional.<ECKeyPair>absent());
    }

    if (!sessionRecord.isFresh()) sessionRecord.archiveCurrentState();

    RatchetingSession.initializeSession(sessionRecord.getSessionState(), parameters.create());

    sessionRecord.getSessionState().setLocalRegistrationId(identityKeyStore.getLocalRegistrationId());
    sessionRecord.getSessionState().setRemoteRegistrationId(message.getRegistrationId());
    sessionRecord.getSessionState().setAliceBaseKey(message.getBaseKey().serialize());

    if (message.getPreKeyId().isPresent()) {
      return message.getPreKeyId();
    } else {
      return Optional.absent();
    }
    */
  }

/*
  public void process(PreKeyBundle preKey) throws InvalidKeyException, UntrustedIdentityException {
    synchronized (SessionCipher.SESSION_LOCK) {
      if (!identityKeyStore.isTrustedIdentity(remoteAddress, preKey.getIdentityKey(), IdentityKeyStore.Direction.SENDING)) {
        throw new UntrustedIdentityException(remoteAddress.getName(), preKey.getIdentityKey());
      }

      if (preKey.getSignedPreKey() != null &&
          !Curve.verifySignature(preKey.getIdentityKey().getPublicKey(),
                                 preKey.getSignedPreKey().serialize(),
                                 preKey.getSignedPreKeySignature()))
      {
        throw new InvalidKeyException("Invalid signature on device key!");
      }

      if (preKey.getSignedPreKey() == null) {
        throw new InvalidKeyException("No signed prekey!");
      }

      SessionRecord         sessionRecord        = sessionStore.loadSession(remoteAddress);
      ECKeyPair             ourBaseKey           = Curve.generateKeyPair();
      ECPublicKey           theirSignedPreKey    = preKey.getSignedPreKey();
      Optional<ECPublicKey> theirOneTimePreKey   = Optional.fromNullable(preKey.getPreKey());
      Optional<Integer>     theirOneTimePreKeyId = theirOneTimePreKey.isPresent() ? Optional.of(preKey.getPreKeyId()) :
                                                                                    Optional.<Integer>absent();

      AliceSignalProtocolParameters.Builder parameters = AliceSignalProtocolParameters.newBuilder();

      parameters.setOurBaseKey(ourBaseKey)
                .setOurIdentityKey(identityKeyStore.getIdentityKeyPair())
                .setTheirIdentityKey(preKey.getIdentityKey())
                .setTheirSignedPreKey(theirSignedPreKey)
                .setTheirRatchetKey(theirSignedPreKey)
                .setTheirOneTimePreKey(theirOneTimePreKey);

      if (!sessionRecord.isFresh()) sessionRecord.archiveCurrentState();

      RatchetingSession.initializeSession(sessionRecord.getSessionState(), parameters.create());

      sessionRecord.getSessionState().setUnacknowledgedPreKeyMessage(theirOneTimePreKeyId, preKey.getSignedPreKeyId(), ourBaseKey.getPublicKey());
      sessionRecord.getSessionState().setLocalRegistrationId(identityKeyStore.getLocalRegistrationId());
      sessionRecord.getSessionState().setRemoteRegistrationId(preKey.getRegistrationId());
      sessionRecord.getSessionState().setAliceBaseKey(ourBaseKey.getPublicKey().serialize());

      identityKeyStore.saveIdentity(remoteAddress, preKey.getIdentityKey());
      sessionStore.storeSession(remoteAddress, sessionRecord);
    }
  }
  */

}

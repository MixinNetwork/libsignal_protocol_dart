import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/DecryptionCallback.dart';
import 'package:libsignalprotocoldart/src/SessionBuilder.dart';
import 'package:libsignalprotocoldart/src/SignalProtocolAddress.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/protocol/CiphertextMessage.dart';
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
}

class NullDecryptionCallback implements DecryptionCallback {
  @override
  void handlePlaintext(Uint8List plaintext) {}
}

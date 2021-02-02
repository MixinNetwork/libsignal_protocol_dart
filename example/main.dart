import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  install();
}

void install() {
  var identityKeyPair = KeyHelper.generateIdentityKeyPair();
  var registerationId = KeyHelper.generateRegistrationId(false);

  var preKeys = KeyHelper.generatePreKeys(0, 110);

  var signedPreKey = KeyHelper.generateSignedPreKey(identityKeyPair, 0);

  var sessionStore = InMemorySessionStore();
  var preKeyStore = InMemoryPreKeyStore();
  var signedPreKeyStore = InMemorySignedPreKeyStore();
  var identityStore =
      InMemoryIdentityKeyStore(identityKeyPair, registerationId);

  for (var p in preKeys) {
    preKeyStore.storePreKey(p.id, p);
  }
  signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

  var remoteAddress = SignalProtocolAddress('remote', 1);
  var sessionBuilder = SessionBuilder(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);

  // Should get remote from the server
  var remoteRegId = KeyHelper.generateRegistrationId(false);
  var remoteIdentityKeyPair = KeyHelper.generateIdentityKeyPair();
  var remotePreKeys = KeyHelper.generatePreKeys(0, 110);
  var remoteSignedPreKey =
      KeyHelper.generateSignedPreKey(remoteIdentityKeyPair, 0);

  var retrievedPreKey = PreKeyBundle(
      remoteRegId,
      1,
      remotePreKeys[0].id,
      remotePreKeys[0].getKeyPair().publicKey,
      remoteSignedPreKey.id,
      remoteSignedPreKey.getKeyPair().publicKey,
      remoteSignedPreKey.signature,
      remoteIdentityKeyPair.getPublicKey());

  sessionBuilder.processPreKeyBundle(retrievedPreKey);

  var sessionCipher = SessionCipher(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);
  var ciphertext =
      sessionCipher.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
  print(ciphertext.serialize());
  //deliver(ciphertext);
}

void groupSessioin() {
  var senderKeyName = SenderKeyName("", SignalProtocolAddress("sender", 1));
  var senderKeyStore = InMemorySenderKeyStore();
  var groupSession = GroupCipher(senderKeyStore, senderKeyName);
  groupSession.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
}

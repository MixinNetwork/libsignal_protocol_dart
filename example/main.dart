import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  install();
}

void install() {
  var identityKeyPair = KeyHelper.generateIdentityKeyPair();
  var registerationId = KeyHelper.generateRegistrationId(false);

  var preKeys = KeyHelper.generatePreKeys(0, 110);

  var signedPreKey = KeyHelper.generateSignedPreKey(identityKeyPair, 0);

  // ignore: unused_local_variable
  var sessionStore = InMemorySessionStore();
  var preKeyStore = InMemoryPreKeyStore();
  var signedPreKeyStore = InMemorySignedPreKeyStore();
  // ignore: unused_local_variable
  var identityStore =
      InMemoryIdentityKeyStore(identityKeyPair, registerationId);

  for (var p in preKeys) {
    preKeyStore.storePreKey(p.id, p);
  }
  signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

  var remoteAddress = SignalProtocolAddress("remote", 1);
  var sessionBuilder = SessionBuilder(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);

  // sessionBuilder.processPreKeyBundle(retrievedPreKey);

  var sessionCipher = SessionCipher(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);
  var ciphertext = sessionCipher.encrypt(utf8.encode("Hello Mixin"));

  //deliver(ciphertext);
}

void groupSessioin() {
  var senderKeyName = SenderKeyName("", SignalProtocolAddress("sender", 1));
  var senderKeyStore = InMemorySenderKeyStore();
  var groupSession = GroupCipher(senderKeyStore, senderKeyName);
  groupSession.encrypt(utf8.encode("Hello Mixin"));
}

// @dart=2.9
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

  var bobAddress = SignalProtocolAddress('bob', 1);
  var sessionBuilder = SessionBuilder(
      sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);

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

  var sessionCipher = SessionCipher(
      sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);
  var ciphertext = sessionCipher.encrypt(utf8.encode('Hello Mixin🤣'));
  print(ciphertext);
  print(ciphertext.serialize());
  //deliver(ciphertext);

  var signalProtocolStore =
      InMemorySignalProtocolStore(remoteIdentityKeyPair, 1);
  var aliceAddress = SignalProtocolAddress("alice", 1);
  var remoteSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, aliceAddress);

  for (var p in remotePreKeys) {
    signalProtocolStore.storePreKey(p.id, p);
  }
  signalProtocolStore.storeSignedPreKey(
      remoteSignedPreKey.id, remoteSignedPreKey);

  if (ciphertext.getType() == CiphertextMessage.PREKEY_TYPE) {
    remoteSessionCipher.decryptWithCallback(ciphertext as PreKeySignalMessage,
        (plaintext) {
      print(utf8.decode(plaintext));
    });
  }
}

void groupSessioin() {
  var senderKeyName = SenderKeyName("", SignalProtocolAddress("sender", 1));
  var senderKeyStore = InMemorySenderKeyStore();
  var groupSession = GroupCipher(senderKeyStore, senderKeyName);
  groupSession.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
}

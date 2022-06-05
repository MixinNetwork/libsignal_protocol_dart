import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

Future<void> main() async {
  await install();
  await groupTest();
}

Future<void> install() async {
  final identityKeyPair = generateIdentityKeyPair();
  final registrationId = generateRegistrationId(false);

  final preKeys = generatePreKeys(0, 110);

  final signedPreKey = generateSignedPreKey(identityKeyPair, 0);

  final sessionStore = InMemorySessionStore();
  final preKeyStore = InMemoryPreKeyStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();
  final identityStore =
      InMemoryIdentityKeyStore(identityKeyPair, registrationId);

  for (final p in preKeys) {
    await preKeyStore.storePreKey(p.id, p);
  }
  await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

  const bobAddress = SignalProtocolAddress('bob', 1);
  final sessionBuilder = SessionBuilder(
      sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);

  // Should get remote from the server
  final remoteRegId = generateRegistrationId(false);
  final remoteIdentityKeyPair = generateIdentityKeyPair();
  final remotePreKeys = generatePreKeys(0, 110);
  final remoteSignedPreKey = generateSignedPreKey(remoteIdentityKeyPair, 0);

  final retrievedPreKey = PreKeyBundle(
      remoteRegId,
      1,
      remotePreKeys[0].id,
      remotePreKeys[0].getKeyPair().publicKey,
      remoteSignedPreKey.id,
      remoteSignedPreKey.getKeyPair().publicKey,
      remoteSignedPreKey.signature,
      remoteIdentityKeyPair.getPublicKey());

  await sessionBuilder.processPreKeyBundle(retrievedPreKey);

  final sessionCipher = SessionCipher(
      sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);
  final ciphertext = await sessionCipher
      .encrypt(Uint8List.fromList(utf8.encode('Hello Mixin🤣')));
  // ignore: avoid_print
  print(ciphertext);
  // ignore: avoid_print
  print(ciphertext.serialize());
  //deliver(ciphertext);

  final signalProtocolStore =
      InMemorySignalProtocolStore(remoteIdentityKeyPair, 1);
  const aliceAddress = SignalProtocolAddress('alice', 1);
  final remoteSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, aliceAddress);

  for (final p in remotePreKeys) {
    await signalProtocolStore.storePreKey(p.id, p);
  }
  await signalProtocolStore.storeSignedPreKey(
      remoteSignedPreKey.id, remoteSignedPreKey);

  if (ciphertext.getType() == CiphertextMessage.prekeyType) {
    await remoteSessionCipher
        .decryptWithCallback(ciphertext as PreKeySignalMessage, (plaintext) {
      // ignore: avoid_print
      print(utf8.decode(plaintext));
    });
  }
}

Future<void> groupTest() async {
  const alice = SignalProtocolAddress('+00000000001', 1);
  const groupSender = SenderKeyName('Private group', alice);
  final aliceStore = InMemorySenderKeyStore();
  final bobStore = InMemorySenderKeyStore();

  final aliceSessionBuilder = GroupSessionBuilder(aliceStore);
  final bobSessionBuilder = GroupSessionBuilder(bobStore);

  final aliceGroupCipher = GroupCipher(aliceStore, groupSender);
  final bobGroupCipher = GroupCipher(bobStore, groupSender);

  final sentAliceDistributionMessage =
      await aliceSessionBuilder.create(groupSender);
  final receivedAliceDistributionMessage =
      SenderKeyDistributionMessageWrapper.fromSerialized(
          sentAliceDistributionMessage.serialize());
  await bobSessionBuilder.process(
      groupSender, receivedAliceDistributionMessage);

  final ciphertextFromAlice = await aliceGroupCipher
      .encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
  final plaintextFromAlice = await bobGroupCipher.decrypt(ciphertextFromAlice);
  // ignore: avoid_print
  print(utf8.decode(plaintextFromAlice));
}

Future<void> groupSession() async {
  const senderKeyName = SenderKeyName('', SignalProtocolAddress('sender', 1));
  final senderKeyStore = InMemorySenderKeyStore();
  final groupSession = GroupCipher(senderKeyStore, senderKeyName);
  await groupSession.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
}

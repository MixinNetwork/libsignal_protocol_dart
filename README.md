# libsignal_protocol_dart

[![pub package](https://img.shields.io/pub/v/libsignal_protocol_dart.svg)](https://pub.dartlang.org/packages/libsignal_protocol_dart)
[![Dart CI](https://github.com/MixinNetwork/libsignal_protocol_dart/workflows/Dart/badge.svg)](https://github.com/MixinNetwork/libsignal_protocol_dart/actions)

libsignal_protocol_dart is a pure Dart/Flutter implementation of the Signal Protocol.

## Documentation

For more information on how the Signal Protocol works:

- [Double Ratchet](https://whispersystems.org/docs/specifications/doubleratchet/)
- [X3DH Key Agreement](https://whispersystems.org/docs/specifications/x3dh/)
- [XEdDSA Signature Schemes](https://whispersystems.org/docs/specifications/xeddsa/)
- [Signal Protocol Java](https://github.com/signalapp/libsignal-protocol-java/)

## Usage

## Install time

At install time, a signal client needs to generate its identity keys, registration id, and prekeys.

```dart
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

  for (var p in preKeys) {
    await preKeyStore.storePreKey(p.id, p);
  }
  await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);
}
```

## Building a session

A signal client needs to implement four interfaces: IdentityKeyStore, PreKeyStore, SignedPreKeyStore, and SessionStore. These will manage loading and storing of identity, prekeys, signed prekeys, and session state.

Once those are implemented, you can build a session in this way:

```dart
  final remoteAddress = SignalProtocolAddress("remote", 1);
  final sessionBuilder = SessionBuilder(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);

  sessionBuilder.processPreKeyBundle(retrievedPreKey);

  final sessionCipher = SessionCipher(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);
  final ciphertext = sessionCipher.encrypt(utf8.encode("Hello Mixin"));

  deliver(ciphertext);
```

## Building a group session

If you wanna send message to a group, send a SenderKeyDistributionMessage to all members of the group.

```dart
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
```

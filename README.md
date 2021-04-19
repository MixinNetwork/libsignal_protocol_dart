# libsignal_protocol_dart

[![Dart CI](https://github.com/MixinNetwork/libsignal_protocol_dart/workflows/Dart%20CI/badge.svg)](https://github.com/MixinNetwork/libsignal_protocol_dart/actions)

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
}
```

## Building a session

A signal client needs to implement four interfaces: IdentityKeyStore, PreKeyStore, SignedPreKeyStore, and SessionStore. These will manage loading and storing of identity, prekeys, signed prekeys, and session state.

Once those are implemented, you can build a session in this way:

```dart
  var remoteAddress = SignalProtocolAddress("remote", 1);
  var sessionBuilder = SessionBuilder(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);

  sessionBuilder.processPreKeyBundle(retrievedPreKey);

  var sessionCipher = SessionCipher(sessionStore, preKeyStore,
      signedPreKeyStore, identityStore, remoteAddress);
  var ciphertext = sessionCipher.encrypt(utf8.encode("Hello Mixin"));

  deliver(ciphertext);
```

## Building a group session

If you wanna send message to a group, send a SenderKeyDistributionMessage to all members of the group.

```dart
  final SENDER_ADDRESS = SignalProtocolAddress('+00000000001', 1);
  final GROUP_SENDER =
      SenderKeyName('Private group', SENDER_ADDRESS);
    var aliceStore = InMemorySenderKeyStore();
    var bobStore = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder = GroupSessionBuilder(bobStore);

    var aliceGroupCipher = GroupCipher(aliceStore, GROUP_SENDER);
    var bobGroupCipher = GroupCipher(bobStore, GROUP_SENDER);

    var sentAliceDistributionMessage = aliceSessionBuilder.create(GROUP_SENDER);
    var receivedAliceDistributionMessage =
        SenderKeyDistributionMessageWrapper.fromSerialized(
            sentAliceDistributionMessage.serialize());
    bobSessionBuilder.process(GROUP_SENDER, receivedAliceDistributionMessage);

    var ciphertextFromAlice = aliceGroupCipher
        .encrypt(Uint8List.fromList(utf8.encode('smert ze smert')));
    var plaintextFromAlice = bobGroupCipher.decrypt(ciphertextFromAlice)
```

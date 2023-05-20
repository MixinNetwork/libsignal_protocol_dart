import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/invalid_key_exception.dart';
import 'package:libsignal_protocol_dart/src/protocol/ciphertext_message.dart';
import 'package:libsignal_protocol_dart/src/protocol/pre_key_signal_message.dart';
import 'package:libsignal_protocol_dart/src/protocol/signal_message.dart';
import 'package:libsignal_protocol_dart/src/session_builder.dart';
import 'package:libsignal_protocol_dart/src/session_cipher.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/pre_key_bundle.dart';
import 'package:libsignal_protocol_dart/src/state/pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/state/signal_protocol_store.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/untrusted_identity_exception.dart';
import 'package:test/test.dart';

import 'test_in_memory_identity_key_store.dart';
import 'test_in_memory_signal_protocol_store.dart';

void main() {
  const aliceAddress = SignalProtocolAddress('+14151111111', 1);
  const bobAddress = SignalProtocolAddress('+14152222222', 1);

  test('testBasicPreKeyV2', () async {
    final aliceStore = TestInMemorySignalProtocolStore();
    final aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, bobAddress);

    final bobStore = TestInMemorySignalProtocolStore();
    final bobPreKeyPair = Curve.generateKeyPair();
    final bobPreKey = PreKeyBundle(
        await bobStore.getLocalRegistrationId(),
        1,
        31337,
        bobPreKeyPair.publicKey,
        0,
        null,
        null,
        await bobStore
            .getIdentityKeyPair()
            .then((value) => value.getPublicKey()));
    try {
      await aliceSessionBuilder.processPreKeyBundle(bobPreKey);
      throw AssertionError('Should fail with missing unsigned prekey!');
    } on InvalidKeyException {
      // Good!
      return;
    }
  });

  Future<void> runInteraction(
      SignalProtocolStore aliceStore, SignalProtocolStore bobStore) async {
    final aliceSessionCipher = SessionCipher.fromStore(aliceStore, bobAddress);
    final bobSessionCipher = SessionCipher.fromStore(bobStore, aliceAddress);

    const originalMessage = 'smert ze smert';
    final aliceMessage = await aliceSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));

    assert(aliceMessage.getType() == CiphertextMessage.whisperType);

    var plaintext = await bobSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(aliceMessage.serialize()));
    assert(String.fromCharCodes(plaintext) == originalMessage);

    final bobMessage = await bobSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));

    assert(bobMessage.getType() == CiphertextMessage.whisperType);

    plaintext = await aliceSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(bobMessage.serialize()));
    assert(String.fromCharCodes(plaintext) == originalMessage);

    for (var i = 0; i < 10; i++) {
      final loopingMessage =
          '''What do we mean by saying that existence precedes essence?
              We mean that man first of all exists, encounters himself,
              surges up in the world--and defines himself aftward. $i''';
      final aliceLoopingMessage = await aliceSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      final loopingPlaintext = await bobSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    for (var i = 0; i < 10; i++) {
      final loopingMessage =
          '''What do we mean by saying that existence precedes essence?
          We mean that man first of all exists, encounters himself,
          surges up in the world--and defines himself aftward. $i''';
      final bobLoopingMessage = await bobSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      final loopingPlaintext = await aliceSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    final Set<(String, CiphertextMessage)> aliceOutOfOrderMessages =
        HashSet<(String, CiphertextMessage)>();

    for (var i = 0; i < 10; i++) {
      final loopingMessage =
          '''What do we mean by saying that existence precedes essence?
              We mean that man first of all exists, encounters himself,
              surges up in the world--and defines himself aftward. $i''';
      final aliceLoopingMessage = await aliceSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      aliceOutOfOrderMessages.add((loopingMessage, aliceLoopingMessage));
    }

    for (var i = 0; i < 10; i++) {
      final loopingMessage =
          '''What do we mean by saying that existence precedes essence?
              We mean that man first of all exists, encounters himself,
              surges up in the world--and defines himself aftward. $i''';
      final aliceLoopingMessage = await aliceSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      final loopingPlaintext = await bobSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    for (var i = 0; i < 10; i++) {
      final loopingMessage = 'You can only desire based on what you know: $i';
      final bobLoopingMessage = await bobSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      final loopingPlaintext = await aliceSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    for (final aliceOutOfOrderMessage in aliceOutOfOrderMessages) {
      ;
      final outOfOrderPlaintext = await bobSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceOutOfOrderMessage.$2.serialize()));
      assert(String.fromCharCodes(outOfOrderPlaintext) ==
          (aliceOutOfOrderMessage.$1));
    }
  }

  test('testBasicPreKeyV3', () async {
    var aliceStore = TestInMemorySignalProtocolStore();
    var aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, bobAddress);

    final bobStore = TestInMemorySignalProtocolStore();
    var bobPreKeyPair = Curve.generateKeyPair();
    var bobSignedPreKeyPair = Curve.generateKeyPair();
    var bobSignedPreKeySignature = Curve.calculateSignature(
        await bobStore
            .getIdentityKeyPair()
            .then((value) => value.getPrivateKey()),
        bobSignedPreKeyPair.publicKey.serialize());

    var bobPreKey = PreKeyBundle(
        await bobStore.getLocalRegistrationId(),
        1,
        31337,
        bobPreKeyPair.publicKey,
        22,
        bobSignedPreKeyPair.publicKey,
        bobSignedPreKeySignature,
        await bobStore
            .getIdentityKeyPair()
            .then((value) => value.getPublicKey()));
    await aliceSessionBuilder.processPreKeyBundle(bobPreKey);

    assert(await aliceStore.containsSession(bobAddress));
    assert(await aliceStore
            .loadSession(bobAddress)
            .then((value) => value.sessionState.getSessionVersion()) ==
        3);

    const originalMessage = "L'homme est condamné à être libre";
    var aliceSessionCipher = SessionCipher.fromStore(aliceStore, bobAddress);
    var outgoingMessage = await aliceSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));
    assert(outgoingMessage.getType() == CiphertextMessage.prekeyType);

    final incomingMessage = PreKeySignalMessage(outgoingMessage.serialize());
    await bobStore.storePreKey(
        31337, PreKeyRecord(bobPreKey.getPreKeyId()!, bobPreKeyPair));
    await bobStore.storeSignedPreKey(
        22,
        SignedPreKeyRecord(22, Int64(DateTime.now().millisecondsSinceEpoch),
            bobSignedPreKeyPair, bobSignedPreKeySignature));

    final bobSessionCipher = SessionCipher.fromStore(bobStore, aliceAddress);
    var plaintext = await bobSessionCipher.decryptWithCallback(incomingMessage,
        (plaintext) async {
      final result = utf8.decode(plaintext, allowMalformed: true);
      assert(originalMessage == result);
      assert(!await bobStore.containsSession(aliceAddress));
    });

    assert(await bobStore.containsSession(aliceAddress));
    assert(await bobStore
            .loadSession(aliceAddress)
            .then((value) => value.sessionState.getSessionVersion()) ==
        3);
    assert(originalMessage == utf8.decode(plaintext, allowMalformed: true));

    final bobOutgoingMessage = await bobSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));
    assert(bobOutgoingMessage.getType() == CiphertextMessage.whisperType);

    final alicePlaintext = await aliceSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(bobOutgoingMessage.serialize()));
    assert(
        utf8.decode(alicePlaintext, allowMalformed: true) == originalMessage);

    await runInteraction(aliceStore, bobStore);

    aliceStore = TestInMemorySignalProtocolStore();
    aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, bobAddress);
    aliceSessionCipher = SessionCipher.fromStore(aliceStore, bobAddress);

    bobPreKeyPair = Curve.generateKeyPair();
    bobSignedPreKeyPair = Curve.generateKeyPair();
    bobSignedPreKeySignature = Curve.calculateSignature(
        await bobStore
            .getIdentityKeyPair()
            .then((value) => value.getPrivateKey()),
        bobSignedPreKeyPair.publicKey.serialize());
    bobPreKey = PreKeyBundle(
        await bobStore.getLocalRegistrationId(),
        1,
        31338,
        bobPreKeyPair.publicKey,
        23,
        bobSignedPreKeyPair.publicKey,
        bobSignedPreKeySignature,
        await bobStore
            .getIdentityKeyPair()
            .then((value) => value.getPublicKey()));

    await bobStore.storePreKey(
        31338, PreKeyRecord(bobPreKey.getPreKeyId()!, bobPreKeyPair));
    await bobStore.storeSignedPreKey(
        23,
        SignedPreKeyRecord(23, Int64(DateTime.now().millisecondsSinceEpoch),
            bobSignedPreKeyPair, bobSignedPreKeySignature));
    await aliceSessionBuilder.processPreKeyBundle(bobPreKey);

    outgoingMessage = await aliceSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));

    try {
      plaintext = await bobSessionCipher
          .decrypt(PreKeySignalMessage(outgoingMessage.serialize()));
      throw AssertionError("shouldn't be trusted!");
    } on UntrustedIdentityException {
      await bobStore.saveIdentity(aliceAddress,
          PreKeySignalMessage(outgoingMessage.serialize()).getIdentityKey());
    }

    plaintext = await bobSessionCipher
        .decrypt(PreKeySignalMessage(outgoingMessage.serialize()));
    assert(utf8.decode(plaintext, allowMalformed: true) == originalMessage);

    bobPreKey = PreKeyBundle(
        await bobStore.getLocalRegistrationId(),
        1,
        31337,
        Curve.generateKeyPair().publicKey,
        23,
        bobSignedPreKeyPair.publicKey,
        bobSignedPreKeySignature,
        await aliceStore
            .getIdentityKeyPair()
            .then((value) => value.getPublicKey()));

    try {
      await aliceSessionBuilder.processPreKeyBundle(bobPreKey);
      throw AssertionError("shoulnd't be trusted!");
    } on UntrustedIdentityException {
      // good
    }
  });

  test('testBadSignedPreKeySignature', () async {
    final aliceStore = TestInMemorySignalProtocolStore();
    final aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, bobAddress);

    final bobIdentityKeyStore = TestInMemoryIdentityKeyStore();

    final bobPreKeyPair = Curve.generateKeyPair();
    final bobSignedPreKeyPair = Curve.generateKeyPair();
    final bobSignedPreKeySignature = Curve.calculateSignature(
        await bobIdentityKeyStore
            .getIdentityKeyPair()
            .then((value) => value.getPrivateKey()),
        bobSignedPreKeyPair.publicKey.serialize());

    for (var i = 0; i < bobSignedPreKeySignature.length * 8; i++) {
      final modifiedSignature = Uint8List(bobSignedPreKeySignature.length);
      Curve.arraycopy(bobSignedPreKeySignature, 0, modifiedSignature, 0,
          modifiedSignature.length);

      modifiedSignature[i ~/ 8] ^= 0x01 << (i % 8);

      final bobPreKey = PreKeyBundle(
          await bobIdentityKeyStore.getLocalRegistrationId(),
          1,
          31337,
          bobPreKeyPair.publicKey,
          22,
          bobSignedPreKeyPair.publicKey,
          modifiedSignature,
          await bobIdentityKeyStore
              .getIdentityKeyPair()
              .then((value) => value.getPublicKey()));

      try {
        await aliceSessionBuilder.processPreKeyBundle(bobPreKey);
        throw AssertionError('Accepted modified device key signature!');
      } on InvalidKeyException {
        // good
      }
    }

    final bobPreKey = PreKeyBundle(
        await bobIdentityKeyStore.getLocalRegistrationId(),
        1,
        31337,
        bobPreKeyPair.publicKey,
        22,
        bobSignedPreKeyPair.publicKey,
        bobSignedPreKeySignature,
        await bobIdentityKeyStore
            .getIdentityKeyPair()
            .then((value) => value.getPublicKey()));

    await aliceSessionBuilder.processPreKeyBundle(bobPreKey);
  });
}

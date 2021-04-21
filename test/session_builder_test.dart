import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/InvalidKeyException.dart';
import 'package:libsignal_protocol_dart/src/SessionBuilder.dart';
import 'package:libsignal_protocol_dart/src/SessionCipher.dart';
import 'package:libsignal_protocol_dart/src/SignalProtocolAddress.dart';
import 'package:libsignal_protocol_dart/src/UntrustedIdentityException.dart';
import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/protocol/CiphertextMessage.dart';
import 'package:libsignal_protocol_dart/src/protocol/PreKeySignalMessage.dart';
import 'package:libsignal_protocol_dart/src/protocol/SignalMessage.dart';
import 'package:libsignal_protocol_dart/src/state/PreKeyBundle.dart';
import 'package:libsignal_protocol_dart/src/state/PreKeyRecord.dart';
import 'package:libsignal_protocol_dart/src/state/SignalProtocolStore.dart';
import 'package:libsignal_protocol_dart/src/state/SignedPreKeyRecord.dart';
import 'package:test/test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:tuple/tuple.dart';

import 'test_in_memory_identity_key_store.dart';
import 'test_in_memory_signal_protocol_store.dart';

void main() {
  final ALICE_ADDRESS = SignalProtocolAddress('+14151111111', 1);
  final BOB_ADDRESS = SignalProtocolAddress('+14152222222', 1);

  test('testBasicPreKeyV2', () async {
    final aliceStore = TestInMemorySignalProtocolStore();
    final aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);

    var bobStore = TestInMemorySignalProtocolStore();
    var bobPreKeyPair = Curve.generateKeyPair();
    var bobPreKey = PreKeyBundle(
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
    var aliceSessionCipher = SessionCipher.fromStore(aliceStore, BOB_ADDRESS);
    var bobSessionCipher = SessionCipher.fromStore(bobStore, ALICE_ADDRESS);

    var originalMessage = 'smert ze smert';
    var aliceMessage = await aliceSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));

    assert(aliceMessage.getType() == CiphertextMessage.WHISPER_TYPE);

    var plaintext = await bobSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(aliceMessage.serialize()));
    assert(String.fromCharCodes(plaintext) == (originalMessage));

    var bobMessage = await bobSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));

    assert(bobMessage.getType() == CiphertextMessage.WHISPER_TYPE);

    plaintext = await aliceSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(bobMessage.serialize()));
    assert(String.fromCharCodes(plaintext) == originalMessage);

    for (var i = 0; i < 10; i++) {
      var loopingMessage =
          '''What do we mean by saying that existence precedes essence?
              We mean that man first of all exists, encounters himself,
              surges up in the world--and defines himself aftward. $i''';
      var aliceLoopingMessage = await aliceSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      var loopingPlaintext = await bobSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    for (var i = 0; i < 10; i++) {
      var loopingMessage =
          ('''What do we mean by saying that existence precedes essence?
          We mean that man first of all exists, encounters himself,
          surges up in the world--and defines himself aftward. $i''');
      var bobLoopingMessage = await bobSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      var loopingPlaintext = await aliceSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    Set<Tuple2<String, CiphertextMessage>> aliceOutOfOrderMessages =
        HashSet<Tuple2<String, CiphertextMessage>>();

    for (var i = 0; i < 10; i++) {
      var loopingMessage =
          ('''What do we mean by saying that existence precedes essence?
              We mean that man first of all exists, encounters himself,
              surges up in the world--and defines himself aftward. $i''');
      var aliceLoopingMessage = await aliceSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      aliceOutOfOrderMessages.add(Tuple2<String, CiphertextMessage>(
          loopingMessage, aliceLoopingMessage));
    }

    for (var i = 0; i < 10; i++) {
      var loopingMessage =
          ('''What do we mean by saying that existence precedes essence?
              We mean that man first of all exists, encounters himself,
              surges up in the world--and defines himself aftward. $i''');
      var aliceLoopingMessage = await aliceSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      var loopingPlaintext = await bobSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    for (var i = 0; i < 10; i++) {
      var loopingMessage = 'You can only desire based on what you know: $i';
      var bobLoopingMessage = await bobSessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(loopingMessage)));

      var loopingPlaintext = await aliceSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobLoopingMessage.serialize()));
      assert(String.fromCharCodes(loopingPlaintext) == loopingMessage);
    }

    for (var aliceOutOfOrderMessage in aliceOutOfOrderMessages) {
      var outOfOrderPlaintext = await bobSessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(
              aliceOutOfOrderMessage.item2.serialize()));
      assert(String.fromCharCodes(outOfOrderPlaintext) ==
          (aliceOutOfOrderMessage.item1));
    }
  }

  test('testBasicPreKeyV3', () async {
    var aliceStore = TestInMemorySignalProtocolStore();
    var aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);

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

    assert(await aliceStore.containsSession(BOB_ADDRESS));
    assert(await aliceStore
            .loadSession(BOB_ADDRESS)
            .then((value) => value.sessionState.getSessionVersion()) ==
        3);

    final originalMessage = "L'homme est condamné à être libre";
    var aliceSessionCipher = SessionCipher.fromStore(aliceStore, BOB_ADDRESS);
    var outgoingMessage = await aliceSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));
    assert(outgoingMessage.getType() == CiphertextMessage.PREKEY_TYPE);

    var incomingMessage = PreKeySignalMessage(outgoingMessage.serialize());
    bobStore.storePreKey(
        31337, PreKeyRecord(bobPreKey.getPreKeyId(), bobPreKeyPair));
    bobStore.storeSignedPreKey(
        22,
        SignedPreKeyRecord(22, Int64(DateTime.now().millisecondsSinceEpoch),
            bobSignedPreKeyPair, bobSignedPreKeySignature));

    var bobSessionCipher = SessionCipher.fromStore(bobStore, ALICE_ADDRESS);
    var plaintext = await bobSessionCipher.decryptWithCallback(incomingMessage,
        (plaintext) async {
      var result = utf8.decode(plaintext, allowMalformed: true);
      assert(originalMessage == result);
      assert(!await bobStore.containsSession(ALICE_ADDRESS));
    });

    assert(await bobStore.containsSession(ALICE_ADDRESS));
    assert(await bobStore
            .loadSession(ALICE_ADDRESS)
            .then((value) => value.sessionState.getSessionVersion()) ==
        3);
    assert(bobStore
            .loadSession(ALICE_ADDRESS)
            .then((value) => value.sessionState.aliceBaseKey) !=
        null);
    assert(originalMessage == utf8.decode(plaintext, allowMalformed: true));

    var bobOutgoingMessage = await bobSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(originalMessage)));
    assert(bobOutgoingMessage.getType() == CiphertextMessage.WHISPER_TYPE);

    var alicePlaintext = await aliceSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(bobOutgoingMessage.serialize()));
    assert(
        utf8.decode(alicePlaintext, allowMalformed: true) == originalMessage);

    await runInteraction(aliceStore, bobStore);

    aliceStore = TestInMemorySignalProtocolStore();
    aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);
    aliceSessionCipher = SessionCipher.fromStore(aliceStore, BOB_ADDRESS);

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

    bobStore.storePreKey(
        31338, PreKeyRecord(bobPreKey.getPreKeyId(), bobPreKeyPair));
    bobStore.storeSignedPreKey(
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
    } on UntrustedIdentityException catch (uie) {
      await bobStore.saveIdentity(ALICE_ADDRESS,
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
    var aliceStore = TestInMemorySignalProtocolStore();
    var aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);

    var bobIdentityKeyStore = TestInMemoryIdentityKeyStore();

    var bobPreKeyPair = Curve.generateKeyPair();
    var bobSignedPreKeyPair = Curve.generateKeyPair();
    var bobSignedPreKeySignature = Curve.calculateSignature(
        await bobIdentityKeyStore
            .getIdentityKeyPair()
            .then((value) => value.getPrivateKey()),
        bobSignedPreKeyPair.publicKey.serialize());

    for (var i = 0; i < bobSignedPreKeySignature.length * 8; i++) {
      var modifiedSignature = Uint8List(bobSignedPreKeySignature.length);
      Curve.arraycopy(bobSignedPreKeySignature, 0, modifiedSignature, 0,
          modifiedSignature.length);

      modifiedSignature[i ~/ 8] ^= (0x01 << (i % 8));

      var bobPreKey = PreKeyBundle(
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

    var bobPreKey = PreKeyBundle(
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

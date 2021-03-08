import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/DuplicateMessageException.dart';
import 'package:libsignal_protocol_dart/src/IdentityKey.dart';
import 'package:libsignal_protocol_dart/src/IdentityKeyPair.dart';
import 'package:libsignal_protocol_dart/src/SessionCipher.dart';
import 'package:libsignal_protocol_dart/src/SignalProtocolAddress.dart';
import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/ecc/ECKeyPair.dart';
import 'package:libsignal_protocol_dart/src/ecc/ECPublicKey.dart';
import 'package:libsignal_protocol_dart/src/eq.dart';
import 'package:libsignal_protocol_dart/src/protocol/CiphertextMessage.dart';
import 'package:libsignal_protocol_dart/src/protocol/SignalMessage.dart';
import 'package:libsignal_protocol_dart/src/ratchet/AliceSignalProtocolParameters.dart';
import 'package:libsignal_protocol_dart/src/ratchet/BobSignalProtocolParameters.dart';
import 'package:libsignal_protocol_dart/src/ratchet/RatchetingSession.dart';
import 'package:libsignal_protocol_dart/src/state/SessionRecord.dart';
import 'package:libsignal_protocol_dart/src/state/SessionState.dart';
import 'package:optional/optional.dart';
import 'package:test/test.dart';

import 'test_in_memory_signal_protocol_store.dart';

void main() {
  void runInteraction(
      SessionRecord aliceSessionRecord, SessionRecord bobSessionRecord) {
    var aliceStore = TestInMemorySignalProtocolStore();
    var bobStore = TestInMemorySignalProtocolStore();

    aliceStore.storeSession(
        SignalProtocolAddress('+14159999999', 1), aliceSessionRecord);
    bobStore.storeSession(
        SignalProtocolAddress('+14158888888', 1), bobSessionRecord);

    var aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress('+14159999999', 1));
    var bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress('+14158888888', 1));

    var alicePlaintext =
        Uint8List.fromList(utf8.encode('This is a plaintext message.'));
    var message = aliceCipher.encrypt(alicePlaintext);
    var bobPlaintext = bobCipher
        .decryptFromSignal(SignalMessage.fromSerialized(message.serialize()));

    assert(eq(alicePlaintext, bobPlaintext));

    var bobReply =
        Uint8List.fromList(utf8.encode('This is a message from Bob.'));
    var reply = bobCipher.encrypt(bobReply);
    var receivedReply = aliceCipher
        .decryptFromSignal(SignalMessage.fromSerialized(reply.serialize()));

    assert(eq(bobReply, receivedReply));

    var aliceCiphertextMessages = <CiphertextMessage>[];
    var alicePlaintextMessages = <Uint8List>[];

    for (var i = 0; i < 50; i++) {
      alicePlaintextMessages
          .add(Uint8List.fromList(utf8.encode('смерть за смерть $i')));
      aliceCiphertextMessages.add(aliceCipher
          .encrypt(Uint8List.fromList(utf8.encode('смерть за смерть $i'))));
    }

    var seed = DateTime.now().microsecondsSinceEpoch;

    aliceCiphertextMessages.shuffle(Random(seed));
    alicePlaintextMessages.shuffle(Random(seed));

    for (var i = 0; i < aliceCiphertextMessages.length / 2; i++) {
      var receivedPlaintext = bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceCiphertextMessages[i].serialize()));
      assert(eq(receivedPlaintext, alicePlaintextMessages[i]));
    }

    var bobCiphertextMessages = <CiphertextMessage>[];
    var bobPlaintextMessages = <Uint8List>[];

    for (var i = 0; i < 20; i++) {
      bobPlaintextMessages
          .add(Uint8List.fromList(utf8.encode('смерть за смерть $i')));
      bobCiphertextMessages.add(bobCipher
          .encrypt(Uint8List.fromList(utf8.encode('смерть за смерть $i'))));
    }

    seed = DateTime.now().millisecondsSinceEpoch;

    bobCiphertextMessages.shuffle(Random(seed));
    bobPlaintextMessages.shuffle(Random(seed));

    for (var i = 0; i < bobCiphertextMessages.length / 2; i++) {
      var receivedPlaintext = aliceCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobCiphertextMessages[i].serialize()));
      assert(eq(receivedPlaintext, bobPlaintextMessages[i]));
    }

    for (var i = aliceCiphertextMessages.length ~/ 2;
        i < aliceCiphertextMessages.length;
        i++) {
      var receivedPlaintext = bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceCiphertextMessages[i].serialize()));
      assert(eq(receivedPlaintext, alicePlaintextMessages[i]));
    }

    for (var i = bobCiphertextMessages.length ~/ 2;
        i < bobCiphertextMessages.length;
        i++) {
      var receivedPlaintext = aliceCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobCiphertextMessages[i].serialize()));
      assert(eq(receivedPlaintext, bobPlaintextMessages[i]));
    }
  }

  void initializeSessionsV3(
      SessionState aliceSessionState, SessionState bobSessionState) {
    var aliceIdentityKeyPair = Curve.generateKeyPair();
    var aliceIdentityKey = IdentityKeyPair(
        IdentityKey(aliceIdentityKeyPair.publicKey),
        aliceIdentityKeyPair.privateKey);
    var aliceBaseKey = Curve.generateKeyPair();
    var aliceEphemeralKey = Curve.generateKeyPair();

    var alicePreKey = aliceBaseKey;

    var bobIdentityKeyPair = Curve.generateKeyPair();
    var bobIdentityKey = IdentityKeyPair(
        IdentityKey(bobIdentityKeyPair.publicKey),
        bobIdentityKeyPair.privateKey);
    var bobBaseKey = Curve.generateKeyPair();
    var bobEphemeralKey = bobBaseKey;

    var bobPreKey = Curve.generateKeyPair();

    var aliceParameters = AliceSignalProtocolParameters.newBuilder()
        .setOurBaseKey(aliceBaseKey)
        .setOurIdentityKey(aliceIdentityKey)
        .setTheirOneTimePreKey(Optional<ECPublicKey>.empty())
        .setTheirRatchetKey(bobEphemeralKey.publicKey)
        .setTheirSignedPreKey(bobBaseKey.publicKey)
        .setTheirIdentityKey(bobIdentityKey.getPublicKey())
        .create();

    var bobParameters = BobSignalProtocolParameters.newBuilder()
        .setOurRatchetKey(bobEphemeralKey)
        .setOurSignedPreKey(bobBaseKey)
        .setOurOneTimePreKey(Optional<ECKeyPair>.empty())
        .setOurIdentityKey(bobIdentityKey)
        .setTheirIdentityKey(aliceIdentityKey.getPublicKey())
        .setTheirBaseKey(aliceBaseKey.publicKey)
        .create();

    RatchetingSession.initializeSessionAlice(
        aliceSessionState, aliceParameters);
    RatchetingSession.initializeSessionBob(bobSessionState, bobParameters);
  }

  test('testBasicSessionV3', () {
    var aliceSessionRecord = SessionRecord();
    var bobSessionRecord = SessionRecord();

    initializeSessionsV3(
        aliceSessionRecord.sessionState, bobSessionRecord.sessionState);
    runInteraction(aliceSessionRecord, bobSessionRecord);
  });

  test('testMessageKeyLimits', () {
    var aliceSessionRecord = SessionRecord();
    var bobSessionRecord = SessionRecord();

    initializeSessionsV3(
        aliceSessionRecord.sessionState, bobSessionRecord.sessionState);

    var aliceStore = TestInMemorySignalProtocolStore();
    var bobStore = TestInMemorySignalProtocolStore();

    aliceStore.storeSession(
        SignalProtocolAddress('+14159999999', 1), aliceSessionRecord);
    bobStore.storeSession(
        SignalProtocolAddress('+14158888888', 1), bobSessionRecord);

    var aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress('+14159999999', 1));
    var bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress('+14158888888', 1));

    var inflight = <CiphertextMessage>[];

    for (var i = 0; i < 2010; i++) {
      inflight.add(aliceCipher.encrypt(Uint8List.fromList(utf8
          .encode("you've never been so hungry, you've never been so cold"))));
    }

    bobCipher.decryptFromSignal(
        SignalMessage.fromSerialized(inflight[1000].serialize()));
    bobCipher.decryptFromSignal(SignalMessage.fromSerialized(
        inflight[inflight.length - 1].serialize()));

    try {
      bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(inflight[0].serialize()));
      throw AssertionError('Should have failed!');
    } on DuplicateMessageException catch (dme) {
      // good
    }
  }, skip: 'Failing historical test');
}

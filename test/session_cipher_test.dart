import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/duplicate_message_exception.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/session_cipher.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/ecc/ec_key_pair.dart';
import 'package:libsignal_protocol_dart/src/ecc/ec_public_key.dart';
import 'package:libsignal_protocol_dart/src/eq.dart';
import 'package:libsignal_protocol_dart/src/protocol/ciphertext_message.dart';
import 'package:libsignal_protocol_dart/src/protocol/signal_message.dart';
import 'package:libsignal_protocol_dart/src/ratchet/alice_signal_protocol_parameters.dart';
import 'package:libsignal_protocol_dart/src/ratchet/bob_signal_protocol_parameters.dart';
import 'package:libsignal_protocol_dart/src/ratchet/ratcheting_session.dart';
import 'package:libsignal_protocol_dart/src/state/session_record.dart';
import 'package:libsignal_protocol_dart/src/state/session_state.dart';
import 'package:optional/optional.dart';
import 'package:test/test.dart';

import 'test_in_memory_signal_protocol_store.dart';

void main() {
  void runInteraction(
      SessionRecord aliceSessionRecord, SessionRecord bobSessionRecord) async {
    var aliceStore = TestInMemorySignalProtocolStore();
    var bobStore = TestInMemorySignalProtocolStore();

    await aliceStore.storeSession(
        SignalProtocolAddress('+14159999999', 1), aliceSessionRecord);
    await bobStore.storeSession(
        SignalProtocolAddress('+14158888888', 1), bobSessionRecord);

    var aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress('+14159999999', 1));
    var bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress('+14158888888', 1));

    var alicePlaintext =
        Uint8List.fromList(utf8.encode('This is a plaintext message.'));
    var message = await aliceCipher.encrypt(alicePlaintext);
    var bobPlaintext = await bobCipher
        .decryptFromSignal(SignalMessage.fromSerialized(message.serialize()));

    assert(eq(alicePlaintext, bobPlaintext));

    var bobReply =
        Uint8List.fromList(utf8.encode('This is a message from Bob.'));
    var reply = await bobCipher.encrypt(bobReply);
    var receivedReply = await aliceCipher
        .decryptFromSignal(SignalMessage.fromSerialized(reply.serialize()));

    assert(eq(bobReply, receivedReply));

    var aliceCiphertextMessages = <CiphertextMessage>[];
    var alicePlaintextMessages = <Uint8List>[];

    for (var i = 0; i < 50; i++) {
      alicePlaintextMessages
          .add(Uint8List.fromList(utf8.encode('смерть за смерть $i')));
      aliceCiphertextMessages.add(await aliceCipher
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
      bobCiphertextMessages.add(await bobCipher
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

  test('testMessageKeyLimits', () async {
    var aliceSessionRecord = SessionRecord();
    var bobSessionRecord = SessionRecord();

    initializeSessionsV3(
        aliceSessionRecord.sessionState, bobSessionRecord.sessionState);

    var aliceStore = TestInMemorySignalProtocolStore();
    var bobStore = TestInMemorySignalProtocolStore();

    await aliceStore.storeSession(
        SignalProtocolAddress('+14159999999', 1), aliceSessionRecord);
    await bobStore.storeSession(
        SignalProtocolAddress('+14158888888', 1), bobSessionRecord);

    var aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress('+14159999999', 1));
    var bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress('+14158888888', 1));

    var inflight = <CiphertextMessage>[];

    for (var i = 0; i < 2010; i++) {
      inflight.add(await aliceCipher.encrypt(Uint8List.fromList(utf8
          .encode("you've never been so hungry, you've never been so cold"))));
    }

    await bobCipher.decryptFromSignal(
        SignalMessage.fromSerialized(inflight[1000].serialize()));
    await bobCipher.decryptFromSignal(SignalMessage.fromSerialized(
        inflight[inflight.length - 1].serialize()));

    try {
      await bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(inflight[0].serialize()));
      throw AssertionError('Should have failed!');
    } on DuplicateMessageException {
      // good
    }
  }, skip: 'Failing historical test');
}

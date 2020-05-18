import 'dart:collection';
import 'dart:convert';

import 'package:libsignal_protocol_dart/src/DuplicateMessageException.dart';
import 'package:libsignal_protocol_dart/src/IdentityKey.dart';
import 'package:libsignal_protocol_dart/src/IdentityKeyPair.dart';
import 'package:libsignal_protocol_dart/src/SessionCipher.dart';
import 'package:libsignal_protocol_dart/src/SignalProtocolAddress.dart';
import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/ecc/ECKeyPair.dart';
import 'package:libsignal_protocol_dart/src/ecc/ECPublicKey.dart';
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
        SignalProtocolAddress("+14159999999", 1), aliceSessionRecord);
    bobStore.storeSession(
        SignalProtocolAddress("+14158888888", 1), bobSessionRecord);

    var aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress("+14159999999", 1));
    var bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress("+14158888888", 1));

    var alicePlaintext = utf8.encode('This is a plaintext message.');
    var message = aliceCipher.encrypt(alicePlaintext);
    var bobPlaintext = bobCipher
        .decryptFromSignal(SignalMessage.fromSerialized(message.serialize()));

    assert(alicePlaintext == bobPlaintext);

/*
    var            bobReply      = "This is a message from Bob.".getBytes();
    CiphertextMessage reply         = bobCipher.encrypt(bobReply);
    byte[]            receivedReply = aliceCipher.decrypt(new SignalMessage(reply.serialize()));

    assertTrue(Arrays.equals(bobReply, receivedReply));

    List<CiphertextMessage> aliceCiphertextMessages = new ArrayList<>();
    List<byte[]>            alicePlaintextMessages  = new ArrayList<>();

    for (int i=0;i<50;i++) {
      alicePlaintextMessages.add(("смерть за смерть " + i).getBytes());
      aliceCiphertextMessages.add(aliceCipher.encrypt(("смерть за смерть " + i).getBytes()));
    }

    long seed = System.currentTimeMillis();

    Collections.shuffle(aliceCiphertextMessages, new Random(seed));
    Collections.shuffle(alicePlaintextMessages, new Random(seed));

    for (int i=0;i<aliceCiphertextMessages.size() / 2;i++) {
      byte[] receivedPlaintext = bobCipher.decrypt(new SignalMessage(aliceCiphertextMessages.get(i).serialize()));
      assertTrue(Arrays.equals(receivedPlaintext, alicePlaintextMessages.get(i)));
    }

    List<CiphertextMessage> bobCiphertextMessages = new ArrayList<>();
    List<byte[]>            bobPlaintextMessages  = new ArrayList<>();

    for (int i=0;i<20;i++) {
      bobPlaintextMessages.add(("смерть за смерть " + i).getBytes());
      bobCiphertextMessages.add(bobCipher.encrypt(("смерть за смерть " + i).getBytes()));
    }

    seed = System.currentTimeMillis();

    Collections.shuffle(bobCiphertextMessages, new Random(seed));
    Collections.shuffle(bobPlaintextMessages, new Random(seed));

    for (int i=0;i<bobCiphertextMessages.size() / 2;i++) {
      byte[] receivedPlaintext = aliceCipher.decrypt(new SignalMessage(bobCiphertextMessages.get(i).serialize()));
      assertTrue(Arrays.equals(receivedPlaintext, bobPlaintextMessages.get(i)));
    }

    for (int i=aliceCiphertextMessages.size()/2;i<aliceCiphertextMessages.size();i++) {
      byte[] receivedPlaintext = bobCipher.decrypt(new SignalMessage(aliceCiphertextMessages.get(i).serialize()));
      assertTrue(Arrays.equals(receivedPlaintext, alicePlaintextMessages.get(i)));
    }

    for (int i=bobCiphertextMessages.size() / 2;i<bobCiphertextMessages.size(); i++) {
      var receivedPlaintext = aliceCipher.decrypt(new SignalMessage(bobCiphertextMessages.get(i).serialize()));
      assert(Arrays.equals(receivedPlaintext, bobPlaintextMessages.get(i)));
    }
    */
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
        SignalProtocolAddress("+14159999999", 1), aliceSessionRecord);
    bobStore.storeSession(
        SignalProtocolAddress("+14158888888", 1), bobSessionRecord);

    var aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress("+14159999999", 1));
    var bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress("+14158888888", 1));

    var inflight = List<CiphertextMessage>();

    for (int i = 0; i < 2010; i++) {
      inflight.add(aliceCipher.encrypt(utf8
          .encode("you've never been so hungry, you've never been so cold")));
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
  });
}

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
import 'package:libsignal_protocol_dart/src/state/SignedPreKeyRecord.dart';
import 'package:test/test.dart';
import 'package:fixnum/fixnum.dart';

import 'test_in_memory_signal_protocol_store.dart';

void main() {
  final ALICE_ADDRESS = SignalProtocolAddress('+14151111111', 1);
  final BOB_ADDRESS = SignalProtocolAddress('+14152222222', 1);

  test('testBasicPreKeyV2', () {
    final aliceStore = TestInMemorySignalProtocolStore();
    final aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);

    var bobStore = TestInMemorySignalProtocolStore();
    var bobPreKeyPair = Curve.generateKeyPair();
    var bobPreKey = PreKeyBundle(
        bobStore.getLocalRegistrationId(),
        1,
        31337,
        bobPreKeyPair.publicKey,
        0,
        null,
        null,
        bobStore.getIdentityKeyPair().getPublicKey());
    try {
      aliceSessionBuilder.processPreKeyBundle(bobPreKey);
      throw AssertionError('Should fail with missing unsigned prekey!');
    } on InvalidKeyException catch (e) {
      // Good!
      return;
    }
  });

  test('testBasicPreKeyV3', (){
    var aliceStore          = TestInMemorySignalProtocolStore();
    var aliceSessionBuilder = SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);

    final bobStore                 = new TestInMemorySignalProtocolStore();
          var    bobPreKeyPair            = Curve.generateKeyPair();
          var    bobSignedPreKeyPair      = Curve.generateKeyPair();
          var       bobSignedPreKeySignature = Curve.calculateSignature(bobStore.getIdentityKeyPair().getPrivateKey(),
                                                                           bobSignedPreKeyPair.publicKey.serialize());

    PreKeyBundle bobPreKey = new PreKeyBundle(bobStore.getLocalRegistrationId(), 1,
                                              31337, bobPreKeyPair.publicKey,
                                              22, bobSignedPreKeyPair.publicKey,
                                              bobSignedPreKeySignature,
                                              bobStore.getIdentityKeyPair().getPublicKey());

    aliceSessionBuilder.processPreKeyBundle(bobPreKey);

    assert(aliceStore.containsSession(BOB_ADDRESS));
    assert(aliceStore.loadSession(BOB_ADDRESS).sessionState.getSessionVersion() == 3);

    final originalMessage    = "L'homme est condamné à être libre";
          var     aliceSessionCipher = SessionCipher.fromStore(aliceStore, BOB_ADDRESS);
          var outgoingMessage    = aliceSessionCipher.encrypt(utf8.encode(originalMessage));

    assert(outgoingMessage.getType() == CiphertextMessage.PREKEY_TYPE);

    var incomingMessage = PreKeySignalMessage(outgoingMessage.serialize());
    bobStore.storePreKey(31337, PreKeyRecord(bobPreKey.getPreKeyId(), bobPreKeyPair));
    bobStore.storeSignedPreKey(22, SignedPreKeyRecord(22, Int64(DateTime.now().millisecondsSinceEpoch), bobSignedPreKeyPair, bobSignedPreKeySignature));

    SessionCipher bobSessionCipher = SessionCipher.fromStore(bobStore, ALICE_ADDRESS);
    var plaintext = bobSessionCipher.decryptWithCallback(incomingMessage, DecryptionCallback() {
      @override
      void handlePlaintext(Uint8List plaintext) {
        assert(originalMessage == String.fromCharCodes(plaintext));
        assert(!bobStore.containsSession(ALICE_ADDRESS));
      }
    });

    assert(bobStore.containsSession(ALICE_ADDRESS));
    assert(bobStore.loadSession(ALICE_ADDRESS).sessionState.getSessionVersion() == 3);
    assert(bobStore.loadSession(ALICE_ADDRESS).sessionState.aliceBaseKey != null);
    assert(originalMessage == String.fromCharCodes(plaintext));

    var bobOutgoingMessage = bobSessionCipher.encrypt(utf8.encode(originalMessage));
    assert(bobOutgoingMessage.getType() == CiphertextMessage.WHISPER_TYPE);

    var alicePlaintext = aliceSessionCipher.decryptFromSignal(SignalMessage.fromSerialized(bobOutgoingMessage.serialize()));
    assert(String.fromCharCodes(alicePlaintext) == originalMessage);

    runInteraction(aliceStore, bobStore);

    aliceStore          = TestInMemorySignalProtocolStore();
    aliceSessionBuilder = SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);
    aliceSessionCipher  = SessionCipher.fromStore(aliceStore, BOB_ADDRESS);

    bobPreKeyPair            = Curve.generateKeyPair();
    bobSignedPreKeyPair      = Curve.generateKeyPair();
    bobSignedPreKeySignature = Curve.calculateSignature(bobStore.getIdentityKeyPair().getPrivateKey(), bobSignedPreKeyPair.publicKey.serialize());
    bobPreKey = PreKeyBundle(bobStore.getLocalRegistrationId(),
                                 1, 31338, bobPreKeyPair.publicKey,
                                 23, bobSignedPreKeyPair.publicKey, bobSignedPreKeySignature,
                                 bobStore.getIdentityKeyPair().getPublicKey());

    bobStore.storePreKey(31338, PreKeyRecord(bobPreKey.getPreKeyId(), bobPreKeyPair));
    bobStore.storeSignedPreKey(23, SignedPreKeyRecord(23, Int64(DateTime.now().millisecondsSinceEpoch), bobSignedPreKeyPair, bobSignedPreKeySignature));
    aliceSessionBuilder.processPreKeyBundle(bobPreKey);

    outgoingMessage = aliceSessionCipher.encrypt(utf8.encode(originalMessage));

    try {
      plaintext = bobSessionCipher.decrypt(PreKeySignalMessage(outgoingMessage.serialize()));
      throw AssertionError("shouldn't be trusted!");
    } on UntrustedIdentityException catch (uie) {
      bobStore.saveIdentity(ALICE_ADDRESS, PreKeySignalMessage(outgoingMessage.serialize()).getIdentityKey());
    }

    plaintext = bobSessionCipher.decrypt(PreKeySignalMessage(outgoingMessage.serialize()));
    assert(String.fromCharCodes(plaintext) ==originalMessage);

    bobPreKey = PreKeyBundle(bobStore.getLocalRegistrationId(), 1,
                                 31337, Curve.generateKeyPair().publicKey,
                                 23, bobSignedPreKeyPair.publicKey, bobSignedPreKeySignature,
                                 aliceStore.getIdentityKeyPair().getPublicKey());

    try {
      aliceSessionBuilder.processPreKeyBundle(bobPreKey);
      throw AssertionError("shoulnd't be trusted!");
    } on UntrustedIdentityException catch (uie) {
      // good
    }
  });
}

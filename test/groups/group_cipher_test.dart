import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/DuplicateMessageException.dart';
import 'package:libsignal_protocol_dart/src/InvalidMessageException.dart';
import 'package:libsignal_protocol_dart/src/NoSessionException.dart';
import 'package:libsignal_protocol_dart/src/SignalProtocolAddress.dart';
import 'package:libsignal_protocol_dart/src/groups/GroupCipher.dart';
import 'package:libsignal_protocol_dart/src/groups/GroupSessionBuilder.dart';
import 'package:libsignal_protocol_dart/src/groups/SenderKeyName.dart';
import 'package:libsignal_protocol_dart/src/protocol/SenderKeyDistributuinMessage.dart';
import 'package:pointycastle/api.dart';
import 'package:test/test.dart';

import 'package:collection/collection.dart';

import 'InMemorySenderKeyStore.dart';

void main() {

  final SENDER_ADDRESS = SignalProtocolAddress('+14150001111', 1);
  final GROUP_SENDER   = SenderKeyName('nihilist history reading group', SENDER_ADDRESS);

  final _integerMax = 0x7fffffff;

  int _randomInt() {
    final secureRandom = Random.secure();
    return secureRandom.nextInt(_integerMax);
  }

  test('testNoSession', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceGroupCipher = GroupCipher(aliceStore, GROUP_SENDER);
    var bobGroupCipher   = GroupCipher(bobStore, GROUP_SENDER);

    var sentAliceDistributionMessage     = aliceSessionBuilder.create(GROUP_SENDER);
    var receivedAliceDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentAliceDistributionMessage.serialize());

//    bobSessionBuilder.process(GROUP_SENDER, receivedAliceDistributionMessage);

    var ciphertextFromAlice = aliceGroupCipher.encrypt(utf8.encode('smert ze smert'));
    try {
      var plaintextFromAlice  = bobGroupCipher.decrypt(ciphertextFromAlice);
      throw AssertionError('Should be no session!');
    } on NoSessionException catch (e) {
    // good
    }
  });

  test('testBasicEncryptDecrypt', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceGroupCipher = GroupCipher(aliceStore, GROUP_SENDER);
    var bobGroupCipher   = GroupCipher(bobStore, GROUP_SENDER);

    var sentAliceDistributionMessage     = aliceSessionBuilder.create(GROUP_SENDER);
    var receivedAliceDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentAliceDistributionMessage.serialize());
    bobSessionBuilder.process(GROUP_SENDER, receivedAliceDistributionMessage);

    var ciphertextFromAlice = aliceGroupCipher.encrypt(utf8.encode('smert ze smert'));
    var plaintextFromAlice  = bobGroupCipher.decrypt(ciphertextFromAlice);

    assert(utf8.decode(plaintextFromAlice) == 'smert ze smert');
  });

  test('testLargeMessages', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceGroupCipher = GroupCipher(aliceStore, GROUP_SENDER);
    var bobGroupCipher   = GroupCipher(bobStore, GROUP_SENDER);

    var sentAliceDistributionMessage     = aliceSessionBuilder.create(GROUP_SENDER);
    var receivedAliceDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentAliceDistributionMessage.serialize());
    bobSessionBuilder.process(GROUP_SENDER, receivedAliceDistributionMessage);

    var secureRandom = SecureRandom("AES/CTR/AUTO-SEED-PRNG");
    final key = Uint8List(32);
    final keyParam = KeyParameter(key);
    secureRandom.seed(keyParam);
    var plaintext = secureRandom.nextBytes(1024 * 1024);

    var ciphertextFromAlice = aliceGroupCipher.encrypt(plaintext);
    var plaintextFromAlice  = bobGroupCipher.decrypt(ciphertextFromAlice);

    Function eq = const ListEquality().equals;
    assert(eq(plaintextFromAlice, plaintext));
  });

  test('testBasicRatchet', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceName = GROUP_SENDER;

    var aliceGroupCipher = GroupCipher(aliceStore, aliceName);
    var bobGroupCipher   = GroupCipher(bobStore, aliceName);

    var sentAliceDistributionMessage = aliceSessionBuilder.create(aliceName);
    var receivedAliceDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentAliceDistributionMessage.serialize());

    bobSessionBuilder.process(aliceName, receivedAliceDistributionMessage);

    var ciphertextFromAlice  = aliceGroupCipher.encrypt(utf8.encode('smert ze smert'));
    var ciphertextFromAlice2 = aliceGroupCipher.encrypt(utf8.encode('smert ze smert2'));
    var ciphertextFromAlice3 = aliceGroupCipher.encrypt(utf8.encode('smert ze smert3'));

    var plaintextFromAlice   = bobGroupCipher.decrypt(ciphertextFromAlice);

    try {
      bobGroupCipher.decrypt(ciphertextFromAlice);
      throw AssertionError('Should have ratcheted forward!');
    } on DuplicateMessageException {
    // good
    }

    var plaintextFromAlice2  = bobGroupCipher.decrypt(ciphertextFromAlice2);
    var plaintextFromAlice3  = bobGroupCipher.decrypt(ciphertextFromAlice3);

    assert(utf8.decode(plaintextFromAlice) == 'smert ze smert');
    assert(utf8.decode(plaintextFromAlice2) == 'smert ze smert2');
    assert(utf8.decode(plaintextFromAlice3) == 'smert ze smert3');
  });

  test('testLateJoin', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);

    var aliceName = GROUP_SENDER;

    var aliceGroupCipher = GroupCipher(aliceStore, aliceName);


    var aliceDistributionMessage = aliceSessionBuilder.create(aliceName);
    // Send off to some people.

    for (var i=0;i<100;i++) {
      aliceGroupCipher.encrypt(utf8.encode('up the punks up the punks up the punks'));
    }

    // Now Bob Joins.
    var bobSessionBuilder = GroupSessionBuilder(bobStore);
    var bobGroupCipher    = GroupCipher(bobStore, aliceName);


    var distributionMessageToBob = aliceSessionBuilder.create(aliceName);
    bobSessionBuilder.process(aliceName, SenderKeyDistributionMessageWrapper.fromSerialized(distributionMessageToBob.serialize()));

    var ciphertext = aliceGroupCipher.encrypt(utf8.encode('welcome to the group'));
    var plaintext  = bobGroupCipher.decrypt(ciphertext);

    assert(utf8.decode(plaintext) == 'welcome to the group');
  });

  test('testOutOfOrder', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceName = GROUP_SENDER;

    var aliceGroupCipher = GroupCipher(aliceStore, aliceName);
    var bobGroupCipher   = GroupCipher(bobStore, aliceName);

    var sentAliceDistributionMessage = aliceSessionBuilder.create(aliceName);
    var receivedAliceDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentAliceDistributionMessage.serialize());

    var aliceDistributionMessage = aliceSessionBuilder.create(aliceName);

    bobSessionBuilder.process(aliceName, aliceDistributionMessage);

    var ciphertexts = [];

    for (var i=0;i<100;i++) {
      ciphertexts.add(aliceGroupCipher.encrypt(utf8.encode('up the punks')));
    }

    while (ciphertexts.isNotEmpty) {
      var    index      = _randomInt() % ciphertexts.length;
      var ciphertext = ciphertexts.removeAt(index);
      var plaintext  = bobGroupCipher.decrypt(ciphertext);

      assert(utf8.decode(plaintext) == 'up the punks');
    }
  });

  test('testEncryptNoSession', () {
    var aliceStore = InMemorySenderKeyStore();
    var aliceGroupCipher = GroupCipher(aliceStore, SenderKeyName('coolio groupio', SignalProtocolAddress('+10002223333', 1)));
    try {
      aliceGroupCipher.encrypt(utf8.encode('up the punks'));
      throw AssertionError('Should have failed!');
    } on NoSessionException {
    // good
    }
  });

  test('testTooFarInFuture', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceName = GROUP_SENDER;

    var aliceGroupCipher = GroupCipher(aliceStore, aliceName);
    var bobGroupCipher   = GroupCipher(bobStore, aliceName);

    var aliceDistributionMessage = aliceSessionBuilder.create(aliceName);

    bobSessionBuilder.process(aliceName, aliceDistributionMessage);

    for (var i=0;i<2001;i++) {
      aliceGroupCipher.encrypt(utf8.encode('up the punks'));
    }

    var tooFarCiphertext = aliceGroupCipher.encrypt(utf8.encode('notta gonna worka'));
    try {
      bobGroupCipher.decrypt(tooFarCiphertext);
      throw AssertionError('Should have failed!');
    } on InvalidMessageException {
    // good
    }
  });

  test('testMessageKeyLimit', () {
    var aliceStore = InMemorySenderKeyStore();
    var bobStore   = InMemorySenderKeyStore();

    var aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    var bobSessionBuilder   = GroupSessionBuilder(bobStore);

    var aliceName = GROUP_SENDER;

    var aliceGroupCipher = GroupCipher(aliceStore, aliceName);
    var bobGroupCipher   = GroupCipher(bobStore, aliceName);

    var aliceDistributionMessage = aliceSessionBuilder.create(aliceName);

    bobSessionBuilder.process(aliceName, aliceDistributionMessage);

    var inflight = [];

    for (var i=0;i<2010;i++) {
      inflight.add(aliceGroupCipher.encrypt(utf8.encode('up the punks')));
    }

    bobGroupCipher.decrypt(inflight[1000]);
    bobGroupCipher.decrypt(inflight[inflight.length-1]);

    try {
      bobGroupCipher.decrypt(inflight[0]);
      throw AssertionError('Should have failed!');
    } on DuplicateMessageException {
    // good
    }
  });
}
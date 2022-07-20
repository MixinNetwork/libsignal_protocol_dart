import 'dart:collection';
import 'dart:typed_data';

import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../entry.dart';
import '../eq.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';
import '../invalid_key_exception.dart';
import '../kdf/hkdf.dart';
import '../ratchet/chain_key.dart';
import '../ratchet/message_keys.dart';
import '../ratchet/root_key.dart';
import 'local_storage_protocol.pb.dart';

class SessionState extends LinkedListEntry<SessionState> {
  SessionState() {
    _sessionStructure = SessionStructure.create();
  }

  SessionState.fromStructure(SessionStructure sessionStructure) {
    _sessionStructure = sessionStructure;
  }

  SessionState.fromSessionState(SessionState copy) {
    _sessionStructure = copy.structure;
  }

  static const int maxMessageKeys = 2000;

  late SessionStructure _sessionStructure;

  SessionStructure get structure => _sessionStructure;

  Uint8List get aliceBaseKey =>
      Uint8List.fromList(_sessionStructure.aliceBaseKey);

  set aliceBaseKey(Uint8List aliceBaseKey) {
    _sessionStructure.aliceBaseKey = aliceBaseKey;
  }

  set sessionVersion(int version) => _sessionStructure.sessionVersion = version;

  int getSessionVersion() {
    final sessionVersion = _sessionStructure.sessionVersion;
    if (sessionVersion == 0) {
      return 2;
    } else {
      return sessionVersion;
    }
  }

  set remoteIdentityKey(IdentityKey identityKey) =>
      _sessionStructure.remoteIdentityPublic = identityKey.serialize();

  set localIdentityKey(IdentityKey identityKey) =>
      _sessionStructure.localIdentityPublic = identityKey.serialize();

  IdentityKey? getRemoteIdentityKey() {
    try {
      if (!_sessionStructure.hasRemoteIdentityPublic()) {
        return null;
      }
      return IdentityKey.fromBytes(
          Uint8List.fromList(_sessionStructure.remoteIdentityPublic), 0);
    } on InvalidKeyException catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

  IdentityKey getLocalIdentityKey() {
    try {
      return IdentityKey.fromBytes(
          Uint8List.fromList(_sessionStructure.localIdentityPublic), 0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  int get previousCounter => _sessionStructure.previousCounter;

  set previousCounter(int previousCounter) =>
      _sessionStructure.previousCounter = previousCounter;

  RootKey getRootKey() => RootKey(HKDF.createFor(getSessionVersion()),
      Uint8List.fromList(_sessionStructure.rootKey));

  set rootKey(RootKey rootKey) =>
      _sessionStructure.rootKey = rootKey.getKeyBytes();

  ECPublicKey getSenderRatchetKey() {
    try {
      return Curve.decodePoint(
          Uint8List.fromList(_sessionStructure.senderChain.senderRatchetKey),
          0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  ECKeyPair getSenderRatchetKeyPair() {
    final publicKey = getSenderRatchetKey();
    final privateKey = Curve.decodePrivatePoint(Uint8List.fromList(
        _sessionStructure.senderChain.senderRatchetKeyPrivate));
    return ECKeyPair(publicKey, privateKey);
  }

  bool hasReceiverChain(ECPublicKey senderEphemeral) =>
      _getReceiverChain(senderEphemeral) != null;

  bool hasSenderChain() => _sessionStructure.hasSenderChain();

  Tuple2<SessionStructureChain, int>? _getReceiverChain(
      ECPublicKey senderEphemeral) {
    final receiverChains = _sessionStructure.receiverChains;
    var index = 0;

    for (final receiverChain in receiverChains) {
      try {
        final chainSenderRatchetKey = Curve.decodePoint(
            Uint8List.fromList(receiverChain.senderRatchetKey), 0);

        if (eq(
            chainSenderRatchetKey.serialize(), senderEphemeral.serialize())) {
          return Tuple2<SessionStructureChain, int>(receiverChain, index);
        }
      } on InvalidKeyException catch (e) {
        // ignore: avoid_print
        print(e);
      }
      index++;
    }

    return null;
  }

  ChainKey? getReceiverChainKey(ECPublicKey senderEphemeral) {
    final receiverChainAndIndex = _getReceiverChain(senderEphemeral);
    final receiverChain = receiverChainAndIndex?.item1;

    if (receiverChain == null) {
      return null;
    } else {
      return ChainKey(
          HKDF.createFor(getSessionVersion()),
          Uint8List.fromList(receiverChain.chainKey.key),
          receiverChain.chainKey.index);
    }
  }

  void addReceiverChain(ECPublicKey senderRatchetKey, ChainKey chainKey) {
    final chainKeyStructure = SessionStructureChainChainKey.create()
      ..key = chainKey.key;

    final chain = SessionStructureChain.create()
      ..chainKey = chainKeyStructure
      ..senderRatchetKey = senderRatchetKey.serialize();

    _sessionStructure.receiverChains.add(chain);

    if (_sessionStructure.receiverChains.length > 5) {
      _sessionStructure.receiverChains.removeAt(0);
    }
  }

  void setSenderChain(ECKeyPair senderRatchetKeyPair, ChainKey chainKey) {
    final chainKeyStructure = SessionStructureChainChainKey.create()
      ..key = chainKey.key
      ..index = chainKey.index;

    final senderChain = SessionStructureChain.create()
      ..senderRatchetKey = senderRatchetKeyPair.publicKey.serialize()
      ..senderRatchetKeyPrivate = senderRatchetKeyPair.privateKey.serialize()
      ..chainKey = chainKeyStructure;
    _sessionStructure.senderChain = senderChain;
  }

  ChainKey getSenderChainKey() {
    final chainKeyStructure = _sessionStructure.senderChain.chainKey;
    return ChainKey(HKDF.createFor(getSessionVersion()),
        Uint8List.fromList(chainKeyStructure.key), chainKeyStructure.index);
  }

  void setSenderChainKey(ChainKey nextChainKey) {
    final chainKey = SessionStructureChainChainKey.create()
      ..key = nextChainKey.key
      ..index = nextChainKey.index;

    _sessionStructure.senderChain.chainKey = chainKey;
  }

  bool hasMessageKeys(ECPublicKey senderEphemeral, int counter) {
    final chainAndIndex = _getReceiverChain(senderEphemeral);
    if (chainAndIndex == null) {
      return false;
    }
    final chain = chainAndIndex.item1;

    final messageKeyList = chain.messageKeys;
    for (final messageKey in messageKeyList) {
      if (messageKey.index == counter) {
        return true;
      }
    }
    return false;
  }

  MessageKeys? removeMessageKeys(ECPublicKey senderEphemeral, int counter) {
    final chainAndIndex = _getReceiverChain(senderEphemeral);
    if (chainAndIndex == null) {
      return null;
    }
    final chain = chainAndIndex.item1;

    final messageKeyList = LinkedList<Entry<SessionStructureChainMessageKey>>();
    chain.messageKeys.forEach((element) {
      messageKeyList.add(Entry(element));
    });
    final messageKeyIterator = messageKeyList.iterator;
    MessageKeys? result;
    while (messageKeyIterator.moveNext()) {
      final entry = messageKeyIterator.current;
      final messageKey = entry.value;
      if (messageKey.index == counter) {
        final cipherKey = Uint8List.fromList(messageKey.cipherKey);
        final macKey = Uint8List.fromList(messageKey.macKey);
        final iv = Uint8List.fromList(messageKey.iv);
        final index = messageKey.index;
        result = MessageKeys(cipherKey, macKey, iv, index);

        messageKeyList.remove(entry);
        break;
      }
    }

    chain.messageKeys.clear();
    messageKeyList.forEach((entry) {
      chain.messageKeys.add(entry.value);
    });

    _sessionStructure.receiverChains
        .setAll(chainAndIndex.item2, <SessionStructureChain>[chain]);
    return result;
  }

  void setMessageKeys(ECPublicKey senderEphemeral, MessageKeys messageKeys) {
    final chainAndIndex = _getReceiverChain(senderEphemeral);
    if (chainAndIndex == null) {
      return;
    }
    final chain = chainAndIndex.item1;
    final messageKeyStructure = SessionStructureChainMessageKey.create()
      ..cipherKey = Uint8List.fromList(messageKeys.getCipherKey())
      ..macKey = Uint8List.fromList(messageKeys.getMacKey())
      ..index = messageKeys.getCounter()
      ..iv = Uint8List.fromList(messageKeys.getIv());

    chain.messageKeys.add(messageKeyStructure);

    if (chain.messageKeys.length > maxMessageKeys) {
      chain.messageKeys.removeAt(0);
    }

    _sessionStructure.receiverChains
        .setAll(chainAndIndex.item2, <SessionStructureChain>[chain]);
  }

  void setReceiverChainKey(ECPublicKey senderEphemeral, ChainKey chainKey) {
    final chainAndIndex = _getReceiverChain(senderEphemeral);
    final chain = chainAndIndex!.item1;

    final chainKeyStructure = SessionStructureChainChainKey.create()
      ..key = chainKey.key
      ..index = chainKey.index;

    chain.chainKey = chainKeyStructure;
    _sessionStructure.receiverChains
        .setAll(chainAndIndex.item2, <SessionStructureChain>[chain]);
  }

  void setPendingKeyExchange(int sequence, ECKeyPair ourBaseKey,
      ECKeyPair ourRatchetKey, IdentityKeyPair ourIdentityKey) {
    final structure = SessionStructurePendingKeyExchange.create()
      ..sequence = sequence
      ..localBaseKey = ourBaseKey.publicKey.serialize()
      ..localBaseKeyPrivate = ourBaseKey.privateKey.serialize()
      ..localRatchetKey = ourRatchetKey.publicKey.serialize()
      ..localRatchetKeyPrivate = ourRatchetKey.privateKey.serialize()
      ..localIdentityKey = ourIdentityKey.getPublicKey().serialize()
      ..localIdentityKeyPrivate = ourIdentityKey.getPrivateKey().serialize();

    _sessionStructure.pendingKeyExchange = structure;
  }

  int getPendingKeyExchangeSequence() =>
      _sessionStructure.pendingKeyExchange.sequence;

  ECKeyPair getPendingKeyExchangeBaseKey() {
    final publicKey = Curve.decodePoint(
        Uint8List.fromList(_sessionStructure.pendingKeyExchange.localBaseKey),
        0);

    final privateKey = Curve.decodePrivatePoint(Uint8List.fromList(
        _sessionStructure.pendingKeyExchange.localBaseKeyPrivate));

    return ECKeyPair(publicKey, privateKey);
  }

  ECKeyPair getPendingKeyExchangeRatchetKey() {
    final publicKey = Curve.decodePointList(
        _sessionStructure.pendingKeyExchange.localRatchetKey, 0);

    final privateKey = Curve.decodePrivatePoint(Uint8List.fromList(
        _sessionStructure.pendingKeyExchange.localRatchetKeyPrivate));

    return ECKeyPair(publicKey, privateKey);
  }

  IdentityKeyPair getPendingKeyExchangeIdentityKey() {
    final publicKey = IdentityKey.fromBytes(
        Uint8List.fromList(
            _sessionStructure.pendingKeyExchange.localIdentityKey),
        0);
    final privateKey = Curve.decodePrivatePoint(Uint8List.fromList(
        _sessionStructure.pendingKeyExchange.localIdentityKeyPrivate));
    return IdentityKeyPair(publicKey, privateKey);
  }

  bool hasPendingKeyExchange() => _sessionStructure.hasPendingKeyExchange();

  void setUnacknowledgedPreKeyMessage(
      Optional<int> preKeyId, int signedPreKeyId, ECPublicKey baseKey) {
    final pending = SessionStructurePendingPreKey.create()
      ..signedPreKeyId = signedPreKeyId
      ..baseKey = baseKey.serialize();

    if (preKeyId.isPresent) {
      pending.preKeyId = preKeyId.value;
    }

    _sessionStructure.pendingPreKey = pending;
  }

  bool hasUnacknowledgedPreKeyMessage() => _sessionStructure.hasPendingPreKey();

  UnacknowledgedPreKeyMessageItems getUnacknowledgedPreKeyMessageItems() {
    try {
      Optional<int> preKeyId;

      if (_sessionStructure.pendingPreKey.hasPreKeyId()) {
        preKeyId = Optional.of(_sessionStructure.pendingPreKey.preKeyId);
      } else {
        preKeyId = const Optional.empty();
      }

      return UnacknowledgedPreKeyMessageItems(
          preKeyId,
          _sessionStructure.pendingPreKey.signedPreKeyId,
          Curve.decodePointList(_sessionStructure.pendingPreKey.baseKey, 0));
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  void clearUnacknowledgedPreKeyMessage() {
    _sessionStructure.clearPendingPreKey();
  }

  set remoteRegistrationId(int registrationId) =>
      _sessionStructure..remoteRegistrationId = registrationId;

  int get remoteRegistrationId => _sessionStructure.remoteRegistrationId;

  set localRegistrationId(int registrationId) =>
      _sessionStructure.localRegistrationId = registrationId;

  int get localRegistrationId => _sessionStructure.localRegistrationId;

  Uint8List serialize() => _sessionStructure.writeToBuffer();
}

class UnacknowledgedPreKeyMessageItems {
  UnacknowledgedPreKeyMessageItems(
      this._preKeyId, this._signedPreKeyId, this._baseKey);

  final Optional<int> _preKeyId;
  final int _signedPreKeyId;
  final ECPublicKey _baseKey;

  Optional<int> getPreKeyId() => _preKeyId;

  int getSignedPreKeyId() => _signedPreKeyId;

  ECPublicKey getBaseKey() => _baseKey;
}

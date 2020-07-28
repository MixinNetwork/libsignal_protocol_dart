import 'dart:collection';
import 'dart:typed_data';

import '../Entry.dart';
import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../InvalidKeyException.dart';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPublicKey.dart';
import '../kdf/HKDF.dart';
import '../ratchet/ChainKey.dart';
import '../ratchet/MessageKeys.dart';
import '../ratchet/RootKey.dart';
import 'LocalStorageProtocol.pb.dart';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

import 'package:collection/collection.dart';

class SessionState extends LinkedListEntry<SessionState> {
  static final int MAX_MESSAGE_KEYS = 2000;

  SessionStructure _sessionStructure;

  SessionState() {
    _sessionStructure = SessionStructure.create();
  }

  SessionState.fromStructure(SessionStructure sessionStructure) {
    _sessionStructure = sessionStructure;
  }

  SessionState.fromSessionState(SessionState copy) {
    _sessionStructure = copy.structure.clone();
  }

  SessionStructure get structure => _sessionStructure;

  Uint8List get aliceBaseKey => _sessionStructure.aliceBaseKey;

  set aliceBaseKey(Uint8List aliceBaseKey) {
    _sessionStructure.aliceBaseKey = aliceBaseKey;
  }

  set sessionVersion(int version) => _sessionStructure.sessionVersion = version;

  int getSessionVersion() {
    var sessionVersion = _sessionStructure.sessionVersion;
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

  IdentityKey getRemoteIdentityKey() {
    try {
      if (!_sessionStructure.hasRemoteIdentityPublic()) {
        return null;
      }
      return IdentityKey.fromBytes(_sessionStructure.remoteIdentityPublic, 0);
    } on InvalidKeyException catch (e) {
      print(e);
      return null;
    }
  }

  IdentityKey getLocalIdentityKey() {
    try {
      return IdentityKey.fromBytes(Uint8List.fromList(_sessionStructure.localIdentityPublic), 0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  int get previousCounter => _sessionStructure.previousCounter;

  set previousCounter(int previousCounter) =>
      _sessionStructure.previousCounter = previousCounter;

  RootKey getRootKey() {
    return RootKey(
        HKDF.createFor(getSessionVersion()), _sessionStructure.rootKey);
  }

  set rootKey(RootKey rootKey) =>
      _sessionStructure.rootKey = rootKey.getKeyBytes();

  ECPublicKey getSenderRatchetKey() {
    try {
      return Curve.decodePoint(
          _sessionStructure.senderChain.senderRatchetKey, 0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  ECKeyPair getSenderRatchetKeyPair() {
    var publicKey = getSenderRatchetKey();
    var privateKey = Curve.decodePrivatePoint(
        _sessionStructure.senderChain.senderRatchetKeyPrivate);
    return ECKeyPair(publicKey, privateKey);
  }

  bool hasReceiverChain(ECPublicKey senderEphemeral) {
    return _getReceiverChain(senderEphemeral) != null;
  }

  bool hasSenderChain() {
    return _sessionStructure.hasSenderChain();
  }

  Tuple2<SessionStructure_Chain, int> _getReceiverChain(
      ECPublicKey senderEphemeral) {
    var receiverChains = _sessionStructure.receiverChains;
    var index = 0;

    for (var receiverChain in receiverChains) {
      try {
        var chainSenderRatchetKey =
            Curve.decodePoint(receiverChain.senderRatchetKey, 0);

        Function eq = ListEquality().equals;
        if (eq(chainSenderRatchetKey.serialize(), senderEphemeral.serialize())) {
          return Tuple2<SessionStructure_Chain, int>(receiverChain, index);
        }
      } on InvalidKeyException catch (e) {
        print(e);
      }
      index++;
    }

    return null;
  }

  ChainKey getReceiverChainKey(ECPublicKey senderEphemeral) {
    var receiverChainAndIndex = _getReceiverChain(senderEphemeral);
    var receiverChain = receiverChainAndIndex.item1;

    if (receiverChain == null) {
      return null;
    } else {
      return ChainKey(HKDF.createFor(getSessionVersion()),
          receiverChain.chainKey.key, receiverChain.chainKey.index);
    }
  }

  void addReceiverChain(ECPublicKey senderRatchetKey, ChainKey chainKey) {
    var chainKeyStructure = SessionStructure_Chain_ChainKey.create()
      ..key = chainKey.key;

    var chain = SessionStructure_Chain.create()
      ..chainKey = chainKeyStructure
      ..senderRatchetKey = senderRatchetKey.serialize();

    _sessionStructure.receiverChains.add(chain);

    if (_sessionStructure.receiverChains.length > 5) {
      _sessionStructure.receiverChains.removeAt(0);
    }
  }

  void setSenderChain(ECKeyPair senderRatchetKeyPair, ChainKey chainKey) {
    var chainKeyStructure = SessionStructure_Chain_ChainKey.create()
      ..key = chainKey.key
      ..index = chainKey.index;

    var senderChain = SessionStructure_Chain.create()
      ..senderRatchetKey = senderRatchetKeyPair.publicKey.serialize()
      ..senderRatchetKeyPrivate = senderRatchetKeyPair.privateKey.serialize()
      ..chainKey = chainKeyStructure;
    _sessionStructure.senderChain = senderChain;
  }

  ChainKey getSenderChainKey() {
    var chainKeyStructure = _sessionStructure.senderChain.chainKey;
    return ChainKey(HKDF.createFor(getSessionVersion()), chainKeyStructure.key,
        chainKeyStructure.index);
  }

  void setSenderChainKey(ChainKey nextChainKey) {
    var chainKey = SessionStructure_Chain_ChainKey.create()
      ..key = nextChainKey.getKey()
      ..index = nextChainKey.getIndex();

    var chain = _sessionStructure.senderChain..chainKey = chainKey;

    _sessionStructure.senderChain = chain;
  }

  bool hasMessageKeys(ECPublicKey senderEphemeral, int counter) {
    var chainAndIndex = _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;

    if (chain == null) {
      return false;
    }

    var messageKeyList = chain.messageKeys;
    for (var messageKey in messageKeyList) {
      if (messageKey.index == counter) {
        return true;
      }
    }
    return false;
  }

  MessageKeys removeMessageKeys(ECPublicKey senderEphemeral, int counter) {
    var chainAndIndex = _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;
    if (chain == null) {
      return null;
    }

    var messageKeyList = LinkedList<Entry<SessionStructure_Chain_MessageKey>>();
    chain.messageKeys.forEach((element) {
      messageKeyList.add(Entry(element));
    });
    var messageKeyIterator = messageKeyList.iterator;
    var result;
    while (messageKeyIterator.moveNext()) {
      var entry = messageKeyIterator.current;
      var messageKey = entry.value;
      if (messageKey.index == counter) {
        var cipherKey = messageKey.writeToBuffer();
        var macKey = messageKey.macKey;
        var iv = messageKey.iv;
        var index = messageKey.index;
        result = MessageKeys(cipherKey, macKey, iv, index);

        messageKeyList.remove(entry);
        break;
      }
    }

    chain.messageKeys.clear();
    messageKeyList.forEach((entry) {
      chain.messageKeys.add(entry.value);
    });

    var newSessionStructure = SessionStructure.create();
    newSessionStructure.receiverChains.insert(chainAndIndex.item2, chain);
    _sessionStructure = newSessionStructure;

    return result;
  }

  void setMessageKeys(ECPublicKey senderEphemeral, MessageKeys messageKeys) {
    var chainAndIndex = _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;
    var messageKeyStructure = SessionStructure_Chain_MessageKey.create()
      ..cipherKey = Uint8List.fromList(messageKeys.getCipherKey())
      ..macKey = Uint8List.fromList(messageKeys.getMacKey())
      ..index = messageKeys.getCounter()
      ..iv = Uint8List.fromList(messageKeys.getIv());

     chain.messageKeys.add(messageKeyStructure);

     if (chain.messageKeys.length > MAX_MESSAGE_KEYS) {
       chain.messageKeys.removeAt(0);
     }

    var newSessionStructure = SessionStructure.create();
     var receiveChains = <SessionStructure_Chain>[];
     receiveChains.add(chain);
    newSessionStructure.receiverChains.addAll(receiveChains);
    _sessionStructure = newSessionStructure;
  }

  void setReceiverChainKey(ECPublicKey senderEphemeral, ChainKey chainKey) {
    var chainAndIndex = _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;

    var chainKeyStructure = SessionStructure_Chain_ChainKey.create()
      ..key = chainKey.key
      ..index = chainKey.index;

    chain.chainKey = chainKeyStructure;
    _sessionStructure.receiverChains.insert(chainAndIndex.item2, chain);
  }

  void setPendingKeyExchange(int sequence, ECKeyPair ourBaseKey,
      ECKeyPair ourRatchetKey, IdentityKeyPair ourIdentityKey) {
    var structure = SessionStructure_PendingKeyExchange.create()
      ..sequence = sequence
      ..localBaseKey = ourBaseKey.publicKey.serialize()
      ..localBaseKeyPrivate = ourBaseKey.privateKey.serialize()
      ..localRatchetKey = ourRatchetKey.publicKey.serialize()
      ..localRatchetKeyPrivate = ourRatchetKey.privateKey.serialize()
      ..localIdentityKey = ourIdentityKey.getPublicKey().serialize()
      ..localIdentityKeyPrivate = ourIdentityKey.getPrivateKey().serialize();

    _sessionStructure.pendingKeyExchange = structure;
  }

  int getPendingKeyExchangeSequence() {
    return _sessionStructure.pendingKeyExchange.sequence;
  }

  ECKeyPair getPendingKeyExchangeBaseKey() {
    var publicKey =
        Curve.decodePoint(_sessionStructure.pendingKeyExchange.localBaseKey, 0);

    var privateKey = Curve.decodePrivatePoint(
        _sessionStructure.pendingKeyExchange.localBaseKeyPrivate);

    return ECKeyPair(publicKey, privateKey);
  }

  ECKeyPair getPendingKeyExchangeRatchetKey() {
    var publicKey = Curve.decodePoint(
        _sessionStructure.pendingKeyExchange.localRatchetKey, 0);

    var privateKey = Curve.decodePrivatePoint(
        _sessionStructure.pendingKeyExchange.localRatchetKeyPrivate);

    return ECKeyPair(publicKey, privateKey);
  }

  IdentityKeyPair getPendingKeyExchangeIdentityKey() {
    var publicKey = IdentityKey.fromBytes(
        _sessionStructure.pendingKeyExchange.localIdentityKey, 0);
    var privateKey = Curve.decodePrivatePoint(
        _sessionStructure.pendingKeyExchange.localIdentityKeyPrivate);
    return IdentityKeyPair(publicKey, privateKey);
  }

  bool hasPendingKeyExchange() {
    return _sessionStructure.hasPendingKeyExchange();
  }

  void setUnacknowledgedPreKeyMessage(
      Optional<int> preKeyId, int signedPreKeyId, ECPublicKey baseKey) {
    var pending = SessionStructure_PendingPreKey.create()
      ..signedPreKeyId = signedPreKeyId
      ..baseKey = baseKey.serialize();

    if (preKeyId.isPresent) {
      pending.preKeyId = preKeyId.value;
    }

    _sessionStructure.pendingPreKey = pending;
  }

  bool hasUnacknowledgedPreKeyMessage() {
    return _sessionStructure.hasPendingPreKey();
  }

  UnacknowledgedPreKeyMessageItems getUnacknowledgedPreKeyMessageItems() {
    try {
      Optional<int> preKeyId;

      if (_sessionStructure.pendingPreKey.hasPreKeyId()) {
        preKeyId = Optional.of(_sessionStructure.pendingPreKey.preKeyId);
      } else {
        preKeyId = Optional.empty();
      }

      return UnacknowledgedPreKeyMessageItems(
          preKeyId,
          _sessionStructure.pendingPreKey.signedPreKeyId,
          Curve.decodePoint(_sessionStructure.pendingPreKey.baseKey, 0));
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

  Uint8List serialize() {
    return _sessionStructure.writeToBuffer();
  }
}

class UnacknowledgedPreKeyMessageItems {
  final Optional<int> _preKeyId;
  final int _signedPreKeyId;
  final ECPublicKey _baseKey;

  UnacknowledgedPreKeyMessageItems(
      this._preKeyId, this._signedPreKeyId, this._baseKey);

  Optional<int> getPreKeyId() {
    return _preKeyId;
  }

  int getSignedPreKeyId() {
    return _signedPreKeyId;
  }

  ECPublicKey getBaseKey() {
    return _baseKey;
  }
}

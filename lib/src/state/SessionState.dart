import 'dart:collection';
import 'dart:typed_data';

import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../InvalidKeyException.dart';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPrivateKey.dart';
import '../ecc/ECPublicKey.dart';
import '../kdf/HKDF.dart';
import '../ratchet/ChainKey.dart';
import '../ratchet/MessageKeys.dart';
import '../ratchet/RootKey.dart';
import 'LocalStorageProtocol.pb.dart';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

class SessionState extends LinkedListEntry<SessionState> {
  static final int MAX_MESSAGE_KEYS = 2000;

  SessionStructure _sessionStructure;

  SessionState() {
    this._sessionStructure = SessionStructure.create();
  }

  SessionState.fromStructure(SessionStructure sessionStructure) {
    this._sessionStructure = sessionStructure;
  }

  SessionState.fromSessionState(SessionState copy) {
    this._sessionStructure = copy._sessionStructure.toBuilder();
  }

  SessionStructure getStructure() {
    return _sessionStructure;
  }

  Uint8List getAliceBaseKey() {
    return this._sessionStructure.aliceBaseKey;
  }

  void setAliceBaseKey(Uint8List aliceBaseKey) {
    this._sessionStructure.aliceBaseKey = aliceBaseKey;
  }

  void setSessionVersion(int version) {
    this._sessionStructure.sessionVersion = version;
  }

  int getSessionVersion() {
    int sessionVersion = this._sessionStructure.sessionVersion;
    if (sessionVersion == 0)
      return 2;
    else
      return sessionVersion;
  }

  void setRemoteIdentityKey(IdentityKey identityKey) {
    this._sessionStructure.remoteIdentityPublic = identityKey.serialize();
  }

  void setLocalIdentityKey(IdentityKey identityKey) {
    this._sessionStructure.localIdentityPublic = identityKey.serialize();
  }

  IdentityKey getRemoteIdentityKey() {
    try {
      if (!this._sessionStructure.hasRemoteIdentityPublic()) {
        return null;
      }
      return IdentityKey.fromBytes(
          this._sessionStructure.remoteIdentityPublic, 0);
    } on InvalidKeyException catch (e) {
      print(e);
      return null;
    }
  }

  IdentityKey getLocalIdentityKey() {
    try {
      return IdentityKey.fromBytes(
          this._sessionStructure.localIdentityPublic, 0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  int getPreviousCounter() {
    return _sessionStructure.previousCounter;
  }

  void setPreviousCounter(int previousCounter) {
    this._sessionStructure.previousCounter = previousCounter;
  }

  RootKey getRootKey() {
    return RootKey(
        HKDF.createFor(getSessionVersion()), this._sessionStructure.rootKey);
  }

  void setRootKey(RootKey rootKey) {
    this._sessionStructure.rootKey = rootKey.getKeyBytes();
  }

  ECPublicKey getSenderRatchetKey() {
    try {
      return Curve.decodePoint(
          _sessionStructure.senderChain.senderRatchetKey, 0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  ECKeyPair getSenderRatchetKeyPair() {
    ECPublicKey publicKey = getSenderRatchetKey();
    ECPrivateKey privateKey = Curve.decodePrivatePoint(
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
    List<SessionStructure_Chain> receiverChains =
        _sessionStructure.receiverChains;
    int index = 0;

    for (SessionStructure_Chain receiverChain in receiverChains) {
      try {
        ECPublicKey chainSenderRatchetKey =
            Curve.decodePoint(receiverChain.senderRatchetKey, 0);

        if (chainSenderRatchetKey == senderEphemeral) {
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
    Tuple2<SessionStructure_Chain, int> receiverChainAndIndex =
        _getReceiverChain(senderEphemeral);
    SessionStructure_Chain receiverChain = receiverChainAndIndex.item1;

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

    this._sessionStructure.receiverChains.add(chain);

    if (this._sessionStructure.receiverChains.length > 5) {
      this._sessionStructure.receiverChains.removeAt(0);
    }
  }

  void setSenderChain(ECKeyPair senderRatchetKeyPair, ChainKey chainKey) {
    var chainKeyStructure = SessionStructure_Chain_ChainKey.create()
      ..key = chainKey.key
      ..index = chainKey.index;

    var senderChain = SessionStructure_Chain.create()
      ..senderRatchetKey = senderRatchetKeyPair.getPublicKey().serialize()
      ..senderRatchetKeyPrivate =
          senderRatchetKeyPair.getPrivateKey().serialize()
      ..chainKey = chainKeyStructure;
    this._sessionStructure.senderChain = senderChain;
  }

  ChainKey getSenderChainKey() {
    SessionStructure_Chain_ChainKey chainKeyStructure =
        _sessionStructure.senderChain.chainKey;
    return ChainKey(HKDF.createFor(getSessionVersion()), chainKeyStructure.key,
        chainKeyStructure.index);
  }

  void setSenderChainKey(ChainKey nextChainKey) {
    var chainKey = SessionStructure_Chain_ChainKey.create()
      ..key = nextChainKey.getKey()
      ..index = nextChainKey.getIndex();

    var chain = _sessionStructure.senderChain..chainKey = chainKey;

    this._sessionStructure.senderChain = chain;
  }

  bool hasMessageKeys(ECPublicKey senderEphemeral, int counter) {
    Tuple2<SessionStructure_Chain, int> chainAndIndex =
        _getReceiverChain(senderEphemeral);
    SessionStructure_Chain chain = chainAndIndex.item1;

    if (chain == null) {
      return false;
    }

    List<SessionStructure_Chain_MessageKey> messageKeyList = chain.messageKeys;
    for (SessionStructure_Chain_MessageKey messageKey in messageKeyList) {
      if (messageKey.index == counter) {
        return true;
      }
    }
    return false;
  }

  MessageKeys removeMessageKeys(ECPublicKey senderEphemeral, int counter) {
    Tuple2<SessionStructure_Chain, int> chainAndIndex =
        _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;
    if (chain == null) {
      return null;
    }

/*
    List<SessionStructure_Chain_MessageKey>     messageKeyList     = new LinkedList<>(chain.getMessageKeysList());
    Iterator<SessionStructure_Chain_MessageKey> messageKeyIterator = messageKeyList.iterator();
    MessageKeys                result             = null;

    while (messageKeyIterator.hasNext()) {
      Chain.MessageKey messageKey = messageKeyIterator.next();

      if (messageKey.getIndex() == counter) {
        result = new MessageKeys(new SecretKeySpec(messageKey.getCipherKey().toByteArray(), "AES"),
                                 new SecretKeySpec(messageKey.getMacKey().toByteArray(), "HmacSHA256"),
                                 new IvParameterSpec(messageKey.getIv().toByteArray()),
                                 messageKey.getIndex());

        messageKeyIterator.remove();
        break;
      }
    }

    var updatedChain = chain.toBuilder().clearMessageKeys()
                              .addAllMessageKeys(messageKeyList)
                              .build();

    this.sessionStructure = this.sessionStructure.toBuilder()
                                                 .setReceiverChains(chainAndIndex.second(), updatedChain)
                                                 .build();
                                                 
    return result;
    */
  }

  void setMessageKeys(ECPublicKey senderEphemeral, MessageKeys messageKeys) {
    Tuple2<SessionStructure_Chain, int> chainAndIndex =
        _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;
    var messageKeyStructure = SessionStructure_Chain_MessageKey.create()
      ..cipherKey = messageKeys.getCipherKey()
      ..macKey = messageKeys.getMacKey()
      ..index = messageKeys.getCounter()
      ..iv = messageKeys.getIv();

/*
    var updatedChain = chain.toBuilder().addMessageKeys(messageKeyStructure);

    if (updatedChain.getMessageKeysCount() > MAX_MESSAGE_KEYS) {
      updatedChain.removeMessageKeys(0);
    }

    this.sessionStructure = this
        .sessionStructure
        .toBuilder()
        .setReceiverChains(chainAndIndex.second(), updatedChain.build())
        .build();
        */
  }

  void setReceiverChainKey(ECPublicKey senderEphemeral, ChainKey chainKey) {
    Tuple2<SessionStructure_Chain, int> chainAndIndex =
        _getReceiverChain(senderEphemeral);
    var chain = chainAndIndex.item1;

    var chainKeyStructure = SessionStructure_Chain_ChainKey.create()
      ..key = chainKey.key
      ..index = chainKey.index;

    var updatedChain = chain.chainKey = chainKeyStructure;
    //TODO this._sessionStructure.receiverChains[chainAndIndex.item2] = updatedChain;
  }

  void setPendingKeyExchange(int sequence, ECKeyPair ourBaseKey,
      ECKeyPair ourRatchetKey, IdentityKeyPair ourIdentityKey) {
    var structure = SessionStructure_PendingKeyExchange.create()
      ..sequence = sequence
      ..localBaseKey = ourBaseKey.getPublicKey().serialize()
      ..localBaseKeyPrivate = ourBaseKey.getPrivateKey().serialize()
      ..localRatchetKey = ourRatchetKey.getPublicKey().serialize()
      ..localRatchetKeyPrivate = ourRatchetKey.getPrivateKey().serialize()
      ..localIdentityKey = ourIdentityKey.getPublicKey().serialize()
      ..localIdentityKeyPrivate = ourIdentityKey.getPrivateKey().serialize();

    this._sessionStructure.pendingKeyExchange = structure;
  }

  int getPendingKeyExchangeSequence() {
    return _sessionStructure.pendingKeyExchange.sequence;
  }

  ECKeyPair getPendingKeyExchangeBaseKey() {
    ECPublicKey publicKey =
        Curve.decodePoint(_sessionStructure.pendingKeyExchange.localBaseKey, 0);

    ECPrivateKey privateKey = Curve.decodePrivatePoint(
        _sessionStructure.pendingKeyExchange.localBaseKeyPrivate);

    return ECKeyPair(publicKey, privateKey);
  }

  ECKeyPair getPendingKeyExchangeRatchetKey() {
    ECPublicKey publicKey = Curve.decodePoint(
        _sessionStructure.pendingKeyExchange.localRatchetKey, 0);

    ECPrivateKey privateKey = Curve.decodePrivatePoint(
        _sessionStructure.pendingKeyExchange.localRatchetKeyPrivate);

    return ECKeyPair(publicKey, privateKey);
  }

  IdentityKeyPair getPendingKeyExchangeIdentityKey() {
    IdentityKey publicKey = IdentityKey.fromBytes(
        _sessionStructure.pendingKeyExchange.localIdentityKey, 0);
    ECPrivateKey privateKey = Curve.decodePrivatePoint(
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

    this._sessionStructure.pendingPreKey = pending;
  }

  bool hasUnacknowledgedPreKeyMessage() {
    return this._sessionStructure.hasPendingPreKey();
  }

  UnacknowledgedPreKeyMessageItems getUnacknowledgedPreKeyMessageItems() {
    try {
      Optional<int> preKeyId;

      if (_sessionStructure.pendingPreKey.hasPreKeyId()) {
        preKeyId = Optional.of(_sessionStructure.pendingPreKey.preKeyId);
      } else {
        preKeyId = Optional.empty();
      }

      return new UnacknowledgedPreKeyMessageItems(
          preKeyId,
          _sessionStructure.pendingPreKey.signedPreKeyId,
          Curve.decodePoint(_sessionStructure.pendingPreKey.baseKey, 0));
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  void clearUnacknowledgedPreKeyMessage() {
    this._sessionStructure.clearPendingPreKey();
  }

  void setRemoteRegistrationId(int registrationId) {
    this._sessionStructure..remoteRegistrationId = registrationId;
  }

  int getRemoteRegistrationId() {
    return this._sessionStructure.remoteRegistrationId;
  }

  void setLocalRegistrationId(int registrationId) {
    this._sessionStructure.localRegistrationId = registrationId;
  }

  int getLocalRegistrationId() {
    return this._sessionStructure.localRegistrationId;
  }

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

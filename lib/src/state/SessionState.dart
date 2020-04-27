import 'dart:collection';
import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/IdentityKey.dart';
import 'package:libsignalprotocoldart/src/InvalidKeyException.dart';
import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPrivateKey.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/kdf/HKDF.dart';
import 'package:libsignalprotocoldart/src/ratchet/ChainKey.dart';
import 'package:libsignalprotocoldart/src/ratchet/RootKey.dart';
import 'package:libsignalprotocoldart/src/state/LocalStorageProtocol.pb.dart';
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
      return Curve.decodePoint(_sessionStructure.senderChain.senderRatchetKey, 0);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

   ECKeyPair getSenderRatchetKeyPair() {
    ECPublicKey  publicKey  = getSenderRatchetKey();
    ECPrivateKey privateKey = Curve.decodePrivatePoint(_sessionStructure.senderChain.senderRatchetKeyPrivate);
    return ECKeyPair(publicKey, privateKey);
  }

   bool hasReceiverChain(ECPublicKey senderEphemeral) {
    return _getReceiverChain(senderEphemeral) != null;
  }

   bool hasSenderChain() {
    return _sessionStructure.hasSenderChain();
  }

   Tuple2<SessionStructure_Chain,int> _getReceiverChain(ECPublicKey senderEphemeral) {
    List<SessionStructure_Chain> receiverChains = _sessionStructure.receiverChains;
    int         index          = 0;

    for (SessionStructure_Chain receiverChain in receiverChains) {
      try {
        ECPublicKey chainSenderRatchetKey = Curve.decodePoint(receiverChain.senderRatchetKey, 0);

        if (chainSenderRatchetKey == senderEphemeral) {
          return Tuple2<SessionStructure_Chain, int>(receiverChain,index);
        }
      } on InvalidKeyException catch (e) {
        print(e);
      }
      index++;
    }

    return null;
  }

  ChainKey getReceiverChainKey(ECPublicKey senderEphemeral) {
    Tuple2<SessionStructure_Chain,int> receiverChainAndIndex = _getReceiverChain(senderEphemeral);
    SessionStructure_Chain               receiverChain         = receiverChainAndIndex.item1;

    if (receiverChain == null) {
      return null;
    } else {
      return ChainKey(HKDF.createFor(getSessionVersion()),
                          receiverChain.chainKey.key,
                          receiverChain.chainKey.index);
    }
  }

  void addReceiverChain(ECPublicKey senderRatchetKey, ChainKey chainKey) {
    SessionStructure_Chain_ChainKey chainKeyStructure = Chain.ChainKey.newBuilder()
                                                     .setKey(ByteString.copyFrom(chainKey.getKey()))
                                                     .setIndex(chainKey.getIndex())
                                                     .build();

    SessionStructure_Chain chain = SessionStructure_Chain.newBuilder()
                       .setChainKey(chainKeyStructure)
                       .setSenderRatchetKey(ByteString.copyFrom(senderRatchetKey.serialize()))
                       .build();

    this._sessionStructure = this.sessionStructure.toBuilder().addReceiverChains(chain).build();

    if (this._sessionStructure.getReceiverChainsList().size() > 5) {
      this._sessionStructure.removeReceiverChains = this.sessionStructure.toBuilder()
                                                   .removeReceiverChains(0)
                                                   .build();
    }
  }

  void setSenderChain(ECKeyPair senderRatchetKeyPair, ChainKey chainKey) {
    SessionStructure_Chain_ChainKey chainKeyStructure = Chain.ChainKey.newBuilder()
                                                     .setKey(ByteString.copyFrom(chainKey.getKey()))
                                                     .setIndex(chainKey.getIndex())
                                                     .build();

    SessionStructure_Chain senderChain = Chain.newBuilder()
                             .setSenderRatchetKey(ByteString.copyFrom(senderRatchetKeyPair.getPublicKey().serialize()))
                             .setSenderRatchetKeyPrivate(ByteString.copyFrom(senderRatchetKeyPair.getPrivateKey().serialize()))
                             .setChainKey(chainKeyStructure)
                             .build();

    this._sessionStructure = this.sessionStructure.toBuilder().setSenderChain(senderChain).build();
  }

  ChainKey getSenderChainKey() {
    SessionStructure_Chain_ChainKey chainKeyStructure = _sessionStructure.senderChain.chainKey;
    return ChainKey(HKDF.createFor(getSessionVersion()),
                        chainKeyStructure.key, chainKeyStructure.index);
  }


  void setSenderChainKey(ChainKey nextChainKey) {
    SessionStructure_Chain_ChainKey chainKey = Chain.ChainKey.newBuilder()
                                            .setKey(ByteString.copyFrom(nextChainKey.getKey()))
                                            .setIndex(nextChainKey.getIndex())
                                            .build();

    SessionStructure_Chain chain = _sessionStructure.getSenderChain().toBuilder()
                                  .setChainKey(chainKey).build();

    this.sessionStructure = this.sessionStructure.toBuilder().setSenderChain(chain).build();
  }

   bool hasMessageKeys(ECPublicKey senderEphemeral, int counter) {
    Tuple2<SessionStructure_Chain,int> chainAndIndex = getReceiverChain(senderEphemeral);
    SessionStructure_Chain               chain         = chainAndIndex.item1;

    if (chain == null) {
      return false;
    }

    List<Chain.MessageKey> messageKeyList = chain.getMessageKeysList();

    for (Chain.MessageKey messageKey : messageKeyList) {
      if (messageKey.getIndex() == counter) {
        return true;
      }
    }

    return false;
  }
}

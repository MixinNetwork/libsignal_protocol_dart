import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPrivateKey.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/groups/ratchet/SenderChainKey.dart';
import 'package:libsignalprotocoldart/src/groups/ratchet/SenderMessageKey.dart';
import 'package:libsignalprotocoldart/src/state/LocalStorageProtocol.pb.dart';
import 'package:optional/optional.dart';

class SenderKeyState {
  static const int _MAX_MESSAGE_KEYS = 2000;

  SenderKeyStateStructure _senderKeyStateStructure;

  SenderKeyState.fromPublicKey(
      int id,
      int iteration,
      Uint8List chainKey,
      ECPublicKey signatureKeyPublic) {
    SenderKeyState(id, iteration, chainKey, signatureKeyPublic,
        Optional.empty());
  }

  SenderKeyState.fromKeyPair(
      int id,
      int iteration,
      Uint8List chainKey,
      ECKeyPair signatureKey) {
    SenderKeyState(id, iteration, chainKey, signatureKey.getPublicKey(),
        Optional.of(signatureKey.getPrivateKey()));
  }

  SenderKeyState(
      int id,
      int iteration,
      Uint8List chainKey,
      ECPublicKey signatureKeyPublic,
      [Optional<ECPrivateKey> signatureKeyPrivate]) {
    var seed = Uint8List.fromList(chainKey);
    seed.addAll(chainKey);
    SenderKeyStateStructure_SenderChainKey senderChainKeyStructure =
        SenderKeyStateStructure_SenderChainKey.create()
          ..iteration = iteration
          ..seed = seed;
    SenderKeyStateStructure_SenderSigningKey signingKeyStructure =
        SenderKeyStateStructure_SenderSigningKey.create()
          ..public = signatureKeyPublic.serialize();
    if (signatureKeyPrivate.isPresent) {
      signingKeyStructure..private = signatureKeyPrivate.value.serialize();
    }
    _senderKeyStateStructure = SenderKeyStateStructure.create()
      ..senderKeyId = id
      ..senderChainKey = senderChainKeyStructure
      ..senderSigningKey = signingKeyStructure;
  }

  SenderKeyState.fromSenderKeyStateStructure(
      SenderKeyStateStructure senderKeyStateStructure) {
    _senderKeyStateStructure = senderKeyStateStructure;
  }

  int get keyId => _senderKeyStateStructure.senderKeyId;

  SenderChainKey get senderChainKey => SenderChainKey(
      _senderKeyStateStructure.senderChainKey.iteration,
      _senderKeyStateStructure.senderChainKey.seed);

  set senderChainKey(SenderChainKey senderChainKey) => {
        _senderKeyStateStructure.senderChainKey =
            SenderKeyStateStructure_SenderChainKey.create()
              ..iteration = senderChainKey.iteration
              ..seed = senderChainKey.seed
      };

  ECPublicKey get SigningKeyPublic =>
      Curve.decodePoint(_senderKeyStateStructure.senderSigningKey.public, 0);

  ECPrivateKey get signingKeyPrivate => Curve.decodePrivatePoint(
      _senderKeyStateStructure.senderSigningKey.private);

  bool hasSenderMessageKey(int iteration) {
    for (var senderMessageKey in _senderKeyStateStructure.senderMessageKeys) {
      if (senderMessageKey.iteration == iteration) {
        return true;
      }
    }
    return false;
  }

  addSenderMessageKey(SenderMessageKey senderMessageKey) {
    SenderKeyStateStructure_SenderMessageKey senderMessageKeyStructure =
        SenderKeyStateStructure_SenderMessageKey.create()
          ..iteration = senderMessageKey.iteration
          ..seed = senderMessageKey.seed;
    _senderKeyStateStructure.senderMessageKeys.add(senderMessageKeyStructure);
    if (_senderKeyStateStructure.senderMessageKeys.length > _MAX_MESSAGE_KEYS) {
      _senderKeyStateStructure.senderMessageKeys.removeAt(0);
    }
  }

  SenderMessageKey removeSenderMessageKey(int iteration) {
    var keys = List.from(_senderKeyStateStructure.senderMessageKeys);
    keys.addAll(_senderKeyStateStructure.senderMessageKeys);
    var index = _senderKeyStateStructure.senderMessageKeys
        .indexWhere((item) => item.iteration == iteration);
    if (index == -1) return null;
    var senderMessageKey = _senderKeyStateStructure.senderMessageKeys.removeAt(index);
    return SenderMessageKey(senderMessageKey.iteration, senderMessageKey.seed);
  }

  SenderKeyStateStructure get structure => _senderKeyStateStructure;
}

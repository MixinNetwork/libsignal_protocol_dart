import 'dart:typed_data';

import 'package:optional/optional.dart';

import '../../ecc/Curve.dart';
import '../../ecc/ECKeyPair.dart';
import '../../ecc/ECPrivateKey.dart';
import '../../ecc/ECPublicKey.dart';
import '../ratchet/SenderChainKey.dart';
import '../ratchet/SenderMessageKey.dart';
import '../../state/LocalStorageProtocol.pb.dart';

class SenderKeyState {
  static const int _MAX_MESSAGE_KEYS = 2000;

  late SenderKeyStateStructure _senderKeyStateStructure;

  SenderKeyState.fromPublicKey(int id, int iteration, Uint8List chainKey,
      ECPublicKey signatureKeyPublic) {
    init(id, iteration, chainKey, signatureKeyPublic, Optional.empty());
  }

  SenderKeyState.fromKeyPair(
      int id, int iteration, Uint8List chainKey, ECKeyPair signatureKey) {
    var signatureKeyPublic = signatureKey.publicKey;
    var signatureKeyPrivate = Optional.of(signatureKey.privateKey);
    init(id, iteration, chainKey, signatureKeyPublic, signatureKeyPrivate);
  }

  void init(
      int id, int iteration, Uint8List chainKey, ECPublicKey signatureKeyPublic,
      [Optional<ECPrivateKey>? signatureKeyPrivate]) {
    var seed = Uint8List.fromList(chainKey);
    var senderChainKeyStructure =
        SenderKeyStateStructure_SenderChainKey.create()
          ..iteration = iteration
          ..seed = seed;
    var signingKeyStructure = SenderKeyStateStructure_SenderSigningKey.create()
      ..public = signatureKeyPublic.serialize();
    if (signatureKeyPrivate!.isPresent) {
      signingKeyStructure.private = signatureKeyPrivate.value.serialize();
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
      Uint8List.fromList(_senderKeyStateStructure.senderChainKey.seed));

  set senderChainKey(SenderChainKey senderChainKey) => {
        _senderKeyStateStructure.senderChainKey =
            SenderKeyStateStructure_SenderChainKey.create()
              ..iteration = senderChainKey.iteration
              ..seed = List.from(senderChainKey.seed)
      };

  ECPublicKey get signingKeyPublic => Curve.decodePointList(
      _senderKeyStateStructure.senderSigningKey.public, 0);

  ECPrivateKey get signingKeyPrivate => Curve.decodePrivatePoint(
      Uint8List.fromList(_senderKeyStateStructure.senderSigningKey.private));

  bool hasSenderMessageKey(int iteration) {
    for (var senderMessageKey in _senderKeyStateStructure.senderMessageKeys) {
      if (senderMessageKey.iteration == iteration) {
        return true;
      }
    }
    return false;
  }

  void addSenderMessageKey(SenderMessageKey senderMessageKey) {
    var senderMessageKeyStructure =
        SenderKeyStateStructure_SenderMessageKey.create()
          ..iteration = senderMessageKey.iteration
          ..seed = senderMessageKey.seed;
    _senderKeyStateStructure.senderMessageKeys.add(senderMessageKeyStructure);
    if (_senderKeyStateStructure.senderMessageKeys.length > _MAX_MESSAGE_KEYS) {
      _senderKeyStateStructure.senderMessageKeys.removeAt(0);
    }
  }

  SenderMessageKey? removeSenderMessageKey(int iteration) {
    var keys = List.from(_senderKeyStateStructure.senderMessageKeys);
    keys.addAll(_senderKeyStateStructure.senderMessageKeys);
    var index = _senderKeyStateStructure.senderMessageKeys
        .indexWhere((item) => item.iteration == iteration);
    if (index == -1) return null;
    var senderMessageKey =
        _senderKeyStateStructure.senderMessageKeys.removeAt(index);
    return SenderMessageKey(
        senderMessageKey.iteration, Uint8List.fromList(senderMessageKey.seed));
  }

  SenderKeyStateStructure get structure => _senderKeyStateStructure;
}

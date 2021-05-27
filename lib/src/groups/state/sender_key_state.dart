import 'dart:typed_data';

import 'package:optional/optional.dart';

import '../../ecc/curve.dart';
import '../../ecc/ec_key_pair.dart';
import '../../ecc/ec_private_key.dart';
import '../../ecc/ec_public_key.dart';
import '../../state/local_storage_protocol.pb.dart';
import '../ratchet/sender_chain_key.dart';
import '../ratchet/sender_message_key.dart';

class SenderKeyState {
  SenderKeyState.fromPublicKey(int id, int iteration, Uint8List chainKey,
      ECPublicKey signatureKeyPublic) {
    init(id, iteration, chainKey, signatureKeyPublic, const Optional.empty());
  }

  SenderKeyState.fromKeyPair(
      int id, int iteration, Uint8List chainKey, ECKeyPair signatureKey) {
    final signatureKeyPublic = signatureKey.publicKey;
    final signatureKeyPrivate = Optional.of(signatureKey.privateKey);
    init(id, iteration, chainKey, signatureKeyPublic, signatureKeyPrivate);
  }

  SenderKeyState.fromSenderKeyStateStructure(
      SenderKeyStateStructure senderKeyStateStructure) {
    _senderKeyStateStructure = senderKeyStateStructure;
  }

  static const int _MAX_MESSAGE_KEYS = 2000;

  late SenderKeyStateStructure _senderKeyStateStructure;

  void init(
      int id, int iteration, Uint8List chainKey, ECPublicKey signatureKeyPublic,
      [Optional<ECPrivateKey>? signatureKeyPrivate]) {
    final seed = Uint8List.fromList(chainKey);
    final senderChainKeyStructure =
        SenderKeyStateStructure_SenderChainKey.create()
          ..iteration = iteration
          ..seed = seed;
    final signingKeyStructure =
        SenderKeyStateStructure_SenderSigningKey.create()
          ..public = signatureKeyPublic.serialize();
    if (signatureKeyPrivate!.isPresent) {
      signingKeyStructure.private = signatureKeyPrivate.value.serialize();
    }
    _senderKeyStateStructure = SenderKeyStateStructure.create()
      ..senderKeyId = id
      ..senderChainKey = senderChainKeyStructure
      ..senderSigningKey = signingKeyStructure;
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
    final senderMessageKeyStructure =
        SenderKeyStateStructure_SenderMessageKey.create()
          ..iteration = senderMessageKey.iteration
          ..seed = senderMessageKey.seed;
    _senderKeyStateStructure.senderMessageKeys.add(senderMessageKeyStructure);
    if (_senderKeyStateStructure.senderMessageKeys.length > _MAX_MESSAGE_KEYS) {
      _senderKeyStateStructure.senderMessageKeys.removeAt(0);
    }
  }

  SenderMessageKey? removeSenderMessageKey(int iteration) {
    List.from(_senderKeyStateStructure.senderMessageKeys)
      ..addAll(_senderKeyStateStructure.senderMessageKeys);
    final index = _senderKeyStateStructure.senderMessageKeys
        .indexWhere((item) => item.iteration == iteration);
    if (index == -1) return null;
    final senderMessageKey =
        _senderKeyStateStructure.senderMessageKeys.removeAt(index);
    return SenderMessageKey(
        senderMessageKey.iteration, Uint8List.fromList(senderMessageKey.seed));
  }

  SenderKeyStateStructure get structure => _senderKeyStateStructure;
}

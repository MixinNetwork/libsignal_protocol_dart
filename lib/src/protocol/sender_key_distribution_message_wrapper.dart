import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';

import '../ecc/curve.dart';
import '../ecc/ec_public_key.dart';
import '../invalid_key_exception.dart';
import '../invalid_message_exception.dart';
import '../legacy_message_exception.dart';
import '../state/whisper_text_protocol.pb.dart';
import '../util/byte_util.dart';
import 'ciphertext_message.dart';

class SenderKeyDistributionMessageWrapper extends CiphertextMessage {
  SenderKeyDistributionMessageWrapper(
      int id, int iteration, Uint8List chainKey, ECPublicKey signatureKey) {
    final version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          CiphertextMessage.CURRENT_VERSION, CiphertextMessage.CURRENT_VERSION)
    ]);
    final protobuf = SenderKeyDistributionMessage.create()
      ..id = id
      ..iteration = iteration
      ..chainKey = List.from(chainKey)
      ..signingKey = List.from(signatureKey.serialize());
    _id = id;
    _iteration = iteration;
    _chainKey = chainKey;
    _signatureKey = signatureKey;
    _serialized = ByteUtil.combine([version, protobuf.writeToBuffer()]);
  }

  SenderKeyDistributionMessageWrapper.fromSerialized(Uint8List serialized) {
    try {
      final messageParts =
          ByteUtil.splitTwo(serialized, 1, serialized.length - 1);
      final version = messageParts[0][0];
      final message = messageParts[1];

      if (ByteUtil.highBitsToInt(version) < CiphertextMessage.CURRENT_VERSION) {
        throw LegacyMessageException(
            'Legacy message: ${ByteUtil.highBitsToInt(version)}');
      }
      if (ByteUtil.highBitsToInt(version) > CiphertextMessage.CURRENT_VERSION) {
        throw InvalidMessageException(
            'Unknown version: ${ByteUtil.highBitsToInt(version)}');
      }

      final distributionMessages =
          SenderKeyDistributionMessage.fromBuffer(message);
      if (!distributionMessages.hasId() ||
          !distributionMessages.hasIteration() ||
          !distributionMessages.hasChainKey() ||
          !distributionMessages.hasSigningKey()) {
        throw InvalidMessageException('Incomplete message.');
      }

      _serialized = serialized;
      _id = distributionMessages.id;
      _iteration = distributionMessages.iteration;
      _chainKey = Uint8List.fromList(distributionMessages.chainKey);
      _signatureKey = Curve.decodePoint(
          Uint8List.fromList(distributionMessages.signingKey), 0);
    } on InvalidProtocolBufferException catch (e) {
      throw InvalidMessageException(e.message);
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  late int _id;
  late int _iteration;
  late Uint8List _chainKey;
  late ECPublicKey _signatureKey;
  late Uint8List _serialized;

  @override
  int getType() => CiphertextMessage.SENDERKEY_DISTRIBUTION_TYPE;

  @override
  Uint8List serialize() => _serialized;

  int get iteration => _iteration;
  Uint8List get chainKey => _chainKey;
  ECPublicKey get signatureKey => _signatureKey;
  int get id => _id;
}

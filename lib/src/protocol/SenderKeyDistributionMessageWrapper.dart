import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/InvalidKeyException.dart';
import 'package:libsignal_protocol_dart/src/InvalidMessageException.dart';
import 'package:libsignal_protocol_dart/src/LegacyMessageException.dart';
import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/ecc/ECPublicKey.dart';
import 'package:libsignal_protocol_dart/src/protocol/CiphertextMessage.dart';
import 'package:libsignal_protocol_dart/src/state/WhisperTextProtocol.pb.dart';
import 'package:libsignal_protocol_dart/src/util/ByteUtil.dart';
import 'package:protobuf/protobuf.dart';

class SenderKeyDistributionMessageWrapper extends CiphertextMessage {
  int _id;
  int _iteration;
  Uint8List _chainKey;
  ECPublicKey _signatureKey;
  Uint8List _serialized;

  SenderKeyDistributionMessageWrapper(
      int id, int iteration, Uint8List chainKey, ECPublicKey signatureKey) {
    var version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          CiphertextMessage.CURRENT_VERSION, CiphertextMessage.CURRENT_VERSION)
    ]);
    var protobuf = SenderKeyDistributionMessage.create()
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
      var messageParts =
          ByteUtil.splitTwo(serialized, 1, serialized.length - 1);
      var version = messageParts[0][0];
      var message = messageParts[1];

      if (ByteUtil.highBitsToInt(version) < CiphertextMessage.CURRENT_VERSION) {
        throw LegacyMessageException(
            'Legacy message: ${ByteUtil.highBitsToInt(version)}');
      }
      if (ByteUtil.highBitsToInt(version) > CiphertextMessage.CURRENT_VERSION) {
        throw InvalidMessageException(
            'Unknown version: ${ByteUtil.highBitsToInt(version)}');
      }

      var distributionMessages =
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

  @override
  int getType() {
    return CiphertextMessage.SENDERKEY_DISTRIBUTION_TYPE;
  }

  @override
  Uint8List serialize() {
    return _serialized;
  }

  int get iteration => _iteration;
  Uint8List get chainKey => _chainKey;
  ECPublicKey get signatureKey => _signatureKey;
  int get id => _id;
}

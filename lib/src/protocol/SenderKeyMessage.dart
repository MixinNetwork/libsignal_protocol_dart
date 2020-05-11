import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/InvalidKeyException.dart';

import '../ecc/Curve.dart';
import '../ecc/ECPublicKey.dart';
import '../ecc/ECPrivateKey.dart';
import '../InvalidKeyIdException.dart';
import '../InvalidMessageException.dart';
import '../LegacyMessageException.dart';
import '../state/WhisperTextProtocol.pb.dart' as protocol;
import '../util/ByteUtil.dart';

import 'CiphertextMessage.dart';

class SenderKeyMessage extends CiphertextMessage {
  static const int SIGNATURE_LENGTH = 64;

  int _messageVersion;
  int _keyId;
  int _iteration;
  Uint8List _ciphertext;
  Uint8List _serialized;

  SenderKeyMessage(int keyId, int iteration, Uint8List ciphertext,
      ECPrivateKey signatureKey) {
    var version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          CiphertextMessage.CURRENT_VERSION, CiphertextMessage.CURRENT_VERSION)
    ]);
    var message = protocol.SenderKeyMessage.create()
      ..id = keyId
      ..iteration = iteration
      ..ciphertext = ciphertext
      ..toBuilder();
    // TODO convert message to Uint8List
//    var signature = _getSignature(signatureKey, ByteUtil.combine([version, message]));
//    _serialized = ByteUtil.combine([version, message, signature]);
    _messageVersion = CiphertextMessage.CURRENT_VERSION;
    _keyId = keyId;
    _iteration = iteration;
    _ciphertext = ciphertext;
  }

  SenderKeyMessage.fromSerialized(Uint8List serialized) {
    var messageParts = ByteUtil.split(serialized, 1,
        serialized.length - 1 - SIGNATURE_LENGTH, SIGNATURE_LENGTH);
    var version = messageParts[0][0];
    var message = messageParts[1];
    var signature = messageParts[2];

    if (ByteUtil.highBitsToInt(version) < 3) {
      throw LegacyMessageException(
          'Legacy message: ${ByteUtil.highBitsToInt(version)}');
    }

    if (ByteUtil.highBitsToInt(version) > CiphertextMessage.CURRENT_VERSION) {
      throw InvalidMessageException(
          'Unknown version: ${ByteUtil.highBitsToInt(version)}');
    }

    var senderKeyMessage = protocol.SenderKeyMessage.fromBuffer(message);

    if (!senderKeyMessage.hasId() ||
        !senderKeyMessage.hasIteration() ||
        !senderKeyMessage.hasCiphertext()) {
      throw InvalidMessageException('Incomplete message.');
    }

    _serialized = serialized;
    _messageVersion = ByteUtil.highBitsToInt(version);
    _keyId = senderKeyMessage.id;
    _iteration = senderKeyMessage.iteration;
    _ciphertext = Uint8List.fromList(senderKeyMessage.ciphertext);
  }

  Uint8List _getSignature(ECPrivateKey signatureKey, Uint8List serialized) {
    try {
      return Curve.calculateSignature(signatureKey, serialized);
    } on InvalidKeyIdException catch (e) {
      throw AssertionError(e);
    }
  }

  int get keyId => _keyId;

  int get iteration => _iteration;

  Uint8List get ciphertext => _ciphertext;

  void verifySignature(ECPublicKey signatureKey) {
    try {
      var parts = ByteUtil.splitTwo(
          _serialized, _serialized.length - SIGNATURE_LENGTH, SIGNATURE_LENGTH);
      if (!Curve.verifySignature(signatureKey, parts[0], parts[1])) {
        throw InvalidMessageException('Invalid signature!');
      }
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  @override
  int getType() {
    return CiphertextMessage.SENDERKEY_TYPE;
  }

  @override
  Uint8List serialize() {
    return _serialized;
  }
}

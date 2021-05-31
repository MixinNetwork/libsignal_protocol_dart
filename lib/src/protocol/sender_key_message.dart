import 'dart:typed_data';

import '../ecc/curve.dart';
import '../ecc/ec_private_key.dart';
import '../ecc/ec_public_key.dart';
import '../invalid_key_exception.dart';
import '../invalid_key_id_exception.dart';
import '../invalid_message_exception.dart';
import '../legacy_message_exception.dart';
import '../state/whisper_text_protocol.pb.dart' as protocol;
import '../util/byte_util.dart';
import 'ciphertext_message.dart';

class SenderKeyMessage extends CiphertextMessage {
  SenderKeyMessage(int keyId, int iteration, Uint8List ciphertext,
      ECPrivateKey signatureKey) {
    final version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          CiphertextMessage.currentVersion, CiphertextMessage.currentVersion)
    ]);
    final message = protocol.SenderKeyMessage.create()
      ..id = keyId
      ..iteration = iteration
      ..ciphertext = ciphertext;
    final messageList = message.writeToBuffer();
    final signature =
        _getSignature(signatureKey, ByteUtil.combine([version, messageList]));
    _serialized = ByteUtil.combine([version, messageList, signature]);
    _messageVersion = CiphertextMessage.currentVersion;
    _keyId = keyId;
    _iteration = iteration;
    _ciphertext = ciphertext;
  }

  SenderKeyMessage.fromSerialized(Uint8List serialized) {
    final messageParts = ByteUtil.split(serialized, 1,
        serialized.length - 1 - signatureLength, signatureLength);
    final version = messageParts[0][0];
    final message = messageParts[1];
    // ignore: unused_local_variable
    final signature = messageParts[2];

    if (ByteUtil.highBitsToInt(version) < 3) {
      throw LegacyMessageException(
          'Legacy message: ${ByteUtil.highBitsToInt(version)}');
    }

    if (ByteUtil.highBitsToInt(version) > CiphertextMessage.currentVersion) {
      throw InvalidMessageException(
          'Unknown version: ${ByteUtil.highBitsToInt(version)}');
    }

    final senderKeyMessage = protocol.SenderKeyMessage.fromBuffer(message);

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

  static const int signatureLength = 64;

  // ignore: unused_field
  late int _messageVersion;
  late int _keyId;
  late int _iteration;
  late Uint8List _ciphertext;
  late Uint8List _serialized;

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
      final parts = ByteUtil.splitTwo(
          _serialized, _serialized.length - signatureLength, signatureLength);
      if (!Curve.verifySignature(signatureKey, parts[0], parts[1])) {
        throw InvalidMessageException('Invalid signature!');
      }
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  @override
  int getType() => CiphertextMessage.senderKeyType;

  @override
  Uint8List serialize() => _serialized;
}

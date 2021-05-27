import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:protobuf/protobuf.dart';

import '../ecc/curve.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../invalid_key_exception.dart';
import '../invalid_message_exception.dart';
import '../legacy_message_exception.dart';
import '../protocol/ciphertext_message.dart';
import '../state/whisper_text_protocol.pb.dart' as signal_protos;
import '../util/byte_util.dart';

class SignalMessage extends CiphertextMessage {
  SignalMessage(
      int messageVersion,
      Uint8List macKey,
      ECPublicKey senderRatchetKey,
      int counter,
      int previousCounter,
      Uint8List ciphertext,
      IdentityKey senderIdentityKey,
      IdentityKey? receiverIdentityKey) {
    final version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          messageVersion, CiphertextMessage.CURRENT_VERSION)
    ]);

    final m = signal_protos.SignalMessage.create()
      ..ratchetKey = senderRatchetKey.serialize()
      ..counter = counter
      ..previousCounter = previousCounter
      ..ciphertext = ciphertext;
    final message = m.writeToBuffer();

    // TODO
    final mac = _getMac(senderIdentityKey, receiverIdentityKey!, macKey,
        ByteUtil.combine([version, message]));

    _serialized = ByteUtil.combine([version, message, mac]);
    _senderRatchetKey = senderRatchetKey;
    _counter = counter;
    _previousCounter = previousCounter;
    _ciphertext = ciphertext;
    _messageVersion = messageVersion;
  }

  SignalMessage.fromSerialized(Uint8List serialized) {
    try {
      final messageParts = ByteUtil.split(
          serialized, 1, serialized.length - 1 - MAC_LENGTH, MAC_LENGTH);
      final version = messageParts[0].first;
      final message = messageParts[1];
      final mac = messageParts[2];

      if (ByteUtil.highBitsToInt(version) < CiphertextMessage.CURRENT_VERSION) {
        throw LegacyMessageException(
            'Legacy message: $ByteUtil.highBitsToInt(version)');
      }

      if (ByteUtil.highBitsToInt(version) > CiphertextMessage.CURRENT_VERSION) {
        throw InvalidMessageException(
            'Unknown version: $ByteUtil.highBitsToInt(version)');
      }

      final whisperMessage = signal_protos.SignalMessage.fromBuffer(message);

      if (!whisperMessage.hasCiphertext() ||
          !whisperMessage.hasCounter() ||
          !whisperMessage.hasRatchetKey()) {
        throw InvalidMessageException('Incomplete message.');
      }

      _serialized = serialized;
      _senderRatchetKey =
          Curve.decodePoint(Uint8List.fromList(whisperMessage.ratchetKey), 0);
      _messageVersion = ByteUtil.highBitsToInt(version);
      _counter = whisperMessage.counter;
      _previousCounter = whisperMessage.previousCounter;
      _ciphertext = Uint8List.fromList(whisperMessage.ciphertext);
    } on InvalidProtocolBufferException catch (e) {
      throw InvalidMessageException(e.toString());
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  static const int MAC_LENGTH = 8;

  late int _messageVersion;
  late ECPublicKey _senderRatchetKey;
  late int _counter;
  late int _previousCounter;
  late Uint8List _ciphertext;
  late Uint8List _serialized;

  ECPublicKey getSenderRatchetKey() => _senderRatchetKey;

  int getMessageVersion() => _messageVersion;

  int getCounter() => _counter;

  Uint8List getBody() => _ciphertext;

  void verifyMac(IdentityKey senderIdentityKey, IdentityKey receiverIdentityKey,
      Uint8List macKey) {
    final parts = ByteUtil.splitTwo(
        _serialized, _serialized.length - MAC_LENGTH, MAC_LENGTH);
    final ourMac =
        _getMac(senderIdentityKey, receiverIdentityKey, macKey, parts[0]);
    final theirMac = parts[1];

    if (Digest(ourMac) != Digest(theirMac)) {
      throw InvalidMessageException('Bad Mac!');
    }
  }

  Uint8List _getMac(IdentityKey senderIdentityKey,
      IdentityKey receiverIdentityKey, Uint8List macKey, Uint8List serialized) {
    final mac = Hmac(sha256, macKey); // HMAC-SHA256

    final output = AccumulatorSink<Digest>();
    mac.startChunkedConversion(output)
      ..add(senderIdentityKey.publicKey.serialize())
      ..add(receiverIdentityKey.publicKey.serialize())
      ..add(serialized)
      ..close();
    final fullMac = Uint8List.fromList(output.events.single.bytes);
    return ByteUtil.trim(fullMac, MAC_LENGTH);
  }

  @override
  int getType() => CiphertextMessage.WHISPER_TYPE;

  @override
  Uint8List serialize() => _serialized;
}

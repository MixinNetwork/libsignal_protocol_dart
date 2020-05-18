import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:protobuf/protobuf.dart';
import '../IdentityKey.dart';
import '../InvalidKeyException.dart';
import '../InvalidMessageException.dart';
import '../LegacyMessageException.dart';
import '../ecc/Curve.dart';
import '../ecc/ECPublicKey.dart';
import '../protocol/CiphertextMessage.dart';
import '../util/ByteUtil.dart';
import '../state/WhisperTextProtocol.pb.dart' as signal_protos;

class SignalMessage extends CiphertextMessage {
  static final int MAC_LENGTH = 8;

  int _messageVersion;
  ECPublicKey _senderRatchetKey;
  int _counter;
  int _previousCounter;
  Uint8List _ciphertext;
  Uint8List _serialized;

  SignalMessage.fromSerialized(Uint8List serialized) {
    try {
      var messageParts = ByteUtil.split(
          serialized, 1, serialized.length - 1 - MAC_LENGTH, MAC_LENGTH);
      var version = messageParts[0].first;
      var message = messageParts[1];
      var mac = messageParts[2];

      if (ByteUtil.highBitsToInt(version) < CiphertextMessage.CURRENT_VERSION) {
        throw LegacyMessageException(
            'Legacy message: $ByteUtil.highBitsToInt(version)');
      }

      if (ByteUtil.highBitsToInt(version) > CiphertextMessage.CURRENT_VERSION) {
        throw InvalidMessageException(
            'Unknown version: $ByteUtil.highBitsToInt(version)');
      }

      var whisperMessage = signal_protos.SignalMessage.fromBuffer(message);

      if (!whisperMessage.hasCiphertext() ||
          !whisperMessage.hasCounter() ||
          !whisperMessage.hasRatchetKey()) {
        throw InvalidMessageException('Incomplete message.');
      }

      _serialized = serialized;
      _senderRatchetKey = Curve.decodePoint(whisperMessage.ratchetKey, 0);
      _messageVersion = ByteUtil.highBitsToInt(version);
      _counter = whisperMessage.counter;
      _previousCounter = whisperMessage.previousCounter;
      _ciphertext = whisperMessage.ciphertext;
    } on InvalidProtocolBufferException catch (e) {
      throw InvalidMessageException('');
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  SignalMessage(
      int messageVersion,
      Uint8List macKey,
      ECPublicKey senderRatchetKey,
      int counter,
      int previousCounter,
      Uint8List ciphertext,
      IdentityKey senderIdentityKey,
      IdentityKey receiverIdentityKey) {
    var version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          messageVersion, CiphertextMessage.CURRENT_VERSION)
    ]);

    var m = signal_protos.SignalMessage.create()
      ..ratchetKey = senderRatchetKey.serialize()
      ..counter = counter
      ..previousCounter = previousCounter
      ..ciphertext = ciphertext;
    var message = m.writeToBuffer();

    var mac = _getMac(senderIdentityKey, receiverIdentityKey, macKey,
        ByteUtil.combine([version, message]));

    _serialized = ByteUtil.combine([version, message, mac]);
    _senderRatchetKey = senderRatchetKey;
    _counter = counter;
    _previousCounter = previousCounter;
    _ciphertext = ciphertext;
    _messageVersion = messageVersion;
  }

  ECPublicKey getSenderRatchetKey() {
    return _senderRatchetKey;
  }

  int getMessageVersion() {
    return _messageVersion;
  }

  int getCounter() {
    return _counter;
  }

  Uint8List getBody() {
    return _ciphertext;
  }

  void verifyMac(IdentityKey senderIdentityKey, IdentityKey receiverIdentityKey,
      Uint8List macKey) {
    var parts = ByteUtil.splitTwo(
        _serialized, _serialized.length - MAC_LENGTH, MAC_LENGTH);
    var ourMac =
        _getMac(senderIdentityKey, receiverIdentityKey, macKey, parts[0]);
    var theirMac = parts[1];

    if (Digest(ourMac) != Digest(theirMac)) {
      throw InvalidMessageException('Bad Mac!');
    }
  }

  Uint8List _getMac(IdentityKey senderIdentityKey,
      IdentityKey receiverIdentityKey, Uint8List macKey, Uint8List serialized) {
    var mac = Hmac(sha256, macKey); // HMAC-SHA256

    var output = AccumulatorSink<Digest>();
    var input = mac.startChunkedConversion(output);
    input.add(senderIdentityKey.publicKey.serialize());
    input.add(receiverIdentityKey.publicKey.serialize());
    input.add(serialized);
    input.close();
    Uint8List fullMac = output.events.single.bytes;
    return ByteUtil.trim(fullMac, MAC_LENGTH);
  }

  @override
  int getType() {
    return CiphertextMessage.WHISPER_TYPE;
  }

  @override
  Uint8List serialize() {
    return _serialized;
  }
}

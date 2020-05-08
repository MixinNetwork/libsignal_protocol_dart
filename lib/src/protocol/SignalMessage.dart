import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import '../IdentityKey.dart';
import '../InvalidMessageException.dart';
import '../LegacyMessageException.dart';
import '../ecc/Curve.dart';
import '../ecc/ECPublicKey.dart';
import '../protocol/CiphertextMessage.dart';
import '../util/ByteUtil.dart';
import '../state/WhisperTextProtocol.pb.dart'
    as SignalProtos;

class SignalMessage extends CiphertextMessage {
  static final int MAC_LENGTH = 8;

  int _messageVersion;
  ECPublicKey _senderRatchetKey;
  int _counter;
  int _previousCounter;
  Uint8List _ciphertext;
  Uint8List _serialized;

  SignalMessage.fromSerialized(Uint8List serialized) {
    // try {
    var messageParts = ByteUtil.split(
        serialized, 1, serialized.length - 1 - MAC_LENGTH, MAC_LENGTH);
    int version = messageParts[0].first;
    Uint8List message = messageParts[1];
    Uint8List mac = messageParts[2];

    if (ByteUtil.highBitsToInt(version) < CiphertextMessage.CURRENT_VERSION) {
      throw LegacyMessageException(
          "Legacy message: $ByteUtil.highBitsToInt(version)");
    }

    if (ByteUtil.highBitsToInt(version) > CiphertextMessage.CURRENT_VERSION) {
      throw InvalidMessageException(
          "Unknown version: $ByteUtil.highBitsToInt(version)");
    }

    SignalProtos.SignalMessage whisperMessage =
        SignalProtos.SignalMessage.fromBuffer(message);

    if (!whisperMessage.hasCiphertext() ||
        !whisperMessage.hasCounter() ||
        !whisperMessage.hasRatchetKey()) {
      throw new InvalidMessageException("Incomplete message.");
    }

    this._serialized = serialized;
    this._senderRatchetKey = Curve.decodePoint(whisperMessage.ratchetKey, 0);
    this._messageVersion = ByteUtil.highBitsToInt(version);
    this._counter = whisperMessage.counter;
    this._previousCounter = whisperMessage.previousCounter;
    this._ciphertext = whisperMessage.ciphertext;
    // } catch (InvalidProtocolBufferException | InvalidKeyException | ParseException e) {
    //   throw new InvalidMessageException(e);
    // }
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
    Uint8List version = Uint8List.fromList([
      ByteUtil.intsToByteHighAndLow(
          messageVersion, CiphertextMessage.CURRENT_VERSION)
    ]);

    var m = SignalProtos.SignalMessage.create()
      ..ratchetKey = senderRatchetKey.serialize()
      ..counter = counter
      ..previousCounter = previousCounter
      ..ciphertext = ciphertext;
    Uint8List message = m.writeToBuffer();

    Uint8List mac = _getMac(senderIdentityKey, receiverIdentityKey, macKey,
        ByteUtil.combine([version, message]));

    this._serialized = ByteUtil.combine([version, message, mac]);
    this._senderRatchetKey = senderRatchetKey;
    this._counter = counter;
    this._previousCounter = previousCounter;
    this._ciphertext = ciphertext;
    this._messageVersion = messageVersion;
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
    List<Uint8List> parts = ByteUtil.splitTwo(
        _serialized, _serialized.length - MAC_LENGTH, MAC_LENGTH);
    Uint8List ourMac =
        _getMac(senderIdentityKey, receiverIdentityKey, macKey, parts[0]);
    Uint8List theirMac = parts[1];

    if (Digest(ourMac) != Digest(theirMac)) {
      throw new InvalidMessageException("Bad Mac!");
    }
  }

  Uint8List _getMac(IdentityKey senderIdentityKey,
      IdentityKey receiverIdentityKey, Uint8List macKey, Uint8List serialized) {
    var mac = Hmac(sha256, macKey); // HMAC-SHA256

    var output = AccumulatorSink<Digest>();
    var input = mac.startChunkedConversion(output);
    input.add(senderIdentityKey.getPublicKey().serialize());
    input.add(receiverIdentityKey.getPublicKey().serialize());
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

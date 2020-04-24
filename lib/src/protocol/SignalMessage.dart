import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/InvalidMessageException.dart';
import 'package:libsignalprotocoldart/src/LegacyMessageException.dart';
import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/protocol/CiphertextMessage.dart';
import 'package:libsignalprotocoldart/src/util/ByteUtil.dart';
import 'package:libsignalprotocoldart/src/state/WhisperTextProtocol.pb.dart'
    as SignalProtos;

class SignalMessage extends CiphertextMessage {
  static final int MAC_LENGTH = 8;

  int _messageVersion;
  ECPublicKey _senderRatchetKey;
  int _counter;
  int _previousCounter;
  Uint8List _ciphertext;
  Uint8List _serialized;

  SignalMessage(Uint8List serialized) {
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

  @override
  int getType() {
    // TODO: implement getType
    throw UnimplementedError();
  }

  @override
  Uint8List serialize() {
    // TODO: implement serialize
    throw UnimplementedError();
  }
}

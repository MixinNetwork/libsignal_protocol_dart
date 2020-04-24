import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/IdentityKey.dart';
import 'package:libsignalprotocoldart/src/InvalidKeyException.dart';
import 'package:libsignalprotocoldart/src/InvalidMessageException.dart';
import 'package:libsignalprotocoldart/src/LegacyMessageException.dart';
import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/protocol/CiphertextMessage.dart';
import 'package:libsignalprotocoldart/src/protocol/SignalMessage.dart';
import 'package:libsignalprotocoldart/src/util/ByteUtil.dart';
import 'package:libsignalprotocoldart/src/state/WhisperTextProtocol.pb.dart' as SignalProtos;

import 'package:optional/optional.dart';

class PreKeySignalMessage extends CiphertextMessage {
  int _version;
  int registrationId;
  Optional<int> preKeyId;
  int signedPreKeyId;
  ECPublicKey baseKey;
  IdentityKey identityKey;
  SignalMessage message;
  Uint8List serialized;

    PreKeySignalMessage(Uint8List serialized)
      // throws InvalidMessageException, InvalidVersionException
  {
    try {
      this._version = ByteUtil.highBitsToInt(serialized[0]);

      var preKeyWhisperMessage
          = SignalProtos.PreKeySignalMessage.fromBuffer(serialized.sublist(1));

      if (!preKeyWhisperMessage.hasSignedPreKeyId()  ||
          !preKeyWhisperMessage.hasBaseKey()         ||
          !preKeyWhisperMessage.hasIdentityKey()     ||
          !preKeyWhisperMessage.hasMessage())
      {
        throw InvalidMessageException("Incomplete message.");
      }

      this.serialized     = serialized;
      this.registrationId = preKeyWhisperMessage.registrationId;
      this.preKeyId       = preKeyWhisperMessage.hasPreKeyId() ? Optional.of(preKeyWhisperMessage.preKeyId) : Optional.<Integer>absent();
      this.signedPreKeyId = preKeyWhisperMessage.hasSignedPreKeyId() ? preKeyWhisperMessage.signedPreKeyId : -1;
      this.baseKey        = Curve.decodePoint(preKeyWhisperMessage.baseKey, 0);
      this.identityKey    = new IdentityKey(Curve.decodePoint(preKeyWhisperMessage.identityKey, 0));
      this.message        = new SignalMessage(preKeyWhisperMessage.message);
    } on InvalidKeyException catch(e) { 
      throw InvalidMessageException(e.detailMessage);
    } on LegacyMessageException catch(e) {
      throw InvalidMessageException(e.detailMessage);
    }
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

import 'dart:typed_data';

import '../IdentityKey.dart';
import '../InvalidKeyException.dart';
import '../InvalidMessageException.dart';
import '../LegacyMessageException.dart';
import '../ecc/Curve.dart';
import '../ecc/ECPublicKey.dart';
import '../protocol/CiphertextMessage.dart';
import '../protocol/SignalMessage.dart';
import '../util/ByteUtil.dart';
import '../state/WhisperTextProtocol.pb.dart' as signal_protos;

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

  PreKeySignalMessage(Uint8List serialized) {
    try {
      _version = ByteUtil.highBitsToInt(serialized[0]);

      var preKeyWhisperMessage =
          signal_protos.PreKeySignalMessage.fromBuffer(serialized.sublist(1));

      if (!preKeyWhisperMessage.hasSignedPreKeyId() ||
          !preKeyWhisperMessage.hasBaseKey() ||
          !preKeyWhisperMessage.hasIdentityKey() ||
          !preKeyWhisperMessage.hasMessage()) {
        throw InvalidMessageException('Incomplete message.');
      }

      this.serialized = serialized;
      registrationId = preKeyWhisperMessage.registrationId;
      preKeyId = preKeyWhisperMessage.hasPreKeyId()
          ? Optional.of(preKeyWhisperMessage.preKeyId)
          : Optional.empty();
      signedPreKeyId = preKeyWhisperMessage.hasSignedPreKeyId()
          ? preKeyWhisperMessage.signedPreKeyId
          : -1;
      baseKey = Curve.decodePoint(preKeyWhisperMessage.baseKey, 0);
      identityKey =
          IdentityKey(Curve.decodePoint(preKeyWhisperMessage.identityKey, 0));
      message = SignalMessage.fromSerialized(preKeyWhisperMessage.message);
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    } on LegacyMessageException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  PreKeySignalMessage.from(
      int messageVersion,
      int registrationId,
      Optional<int> preKeyId,
      int signedPreKeyId,
      ECPublicKey baseKey,
      IdentityKey identityKey,
      SignalMessage message) {
    _version = messageVersion;
    this.registrationId = registrationId;
    this.preKeyId = preKeyId;
    this.signedPreKeyId = signedPreKeyId;
    this.baseKey = baseKey;
    this.identityKey = identityKey;
    this.message = message;

    var builder = signal_protos.PreKeySignalMessage.create()
      ..signedPreKeyId = signedPreKeyId
      ..baseKey = baseKey.serialize()
      ..identityKey = identityKey.serialize()
      ..message = message.serialize()
      ..registrationId = registrationId;

    if (preKeyId.isPresent) {
      builder.preKeyId = preKeyId.value;
    }

    var versionBytes = [
      ByteUtil.intsToByteHighAndLow(_version, CiphertextMessage.CURRENT_VERSION)
    ];

    var messageBytes = builder.toBuilder().writeToBuffer();
    serialized =
        ByteUtil.combine([Uint8List.fromList(versionBytes), messageBytes]);
  }

  int getMessageVersion() {
    return _version;
  }

  IdentityKey getIdentityKey() {
    return identityKey;
  }

  int getRegistrationId() {
    return registrationId;
  }

  Optional<int> getPreKeyId() {
    return preKeyId;
  }

  int getSignedPreKeyId() {
    return signedPreKeyId;
  }

  ECPublicKey getBaseKey() {
    return baseKey;
  }

  SignalMessage getWhisperMessage() {
    return message;
  }

  @override
  int getType() {
    return CiphertextMessage.PREKEY_TYPE;
  }

  @override
  Uint8List serialize() {
    return serialized;
  }
}

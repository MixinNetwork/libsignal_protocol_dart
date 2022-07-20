import 'dart:typed_data';

import 'package:optional/optional.dart';

import '../ecc/curve.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../invalid_key_exception.dart';
import '../invalid_message_exception.dart';
import '../legacy_message_exception.dart';
import '../protocol/ciphertext_message.dart';
import '../protocol/signal_message.dart';
import '../state/whisper_text_protocol.pb.dart' as signal_protos;
import '../util/byte_util.dart';

class PreKeySignalMessage extends CiphertextMessage {
  PreKeySignalMessage(Uint8List serialized) {
    try {
      _version = ByteUtil.highBitsToInt(serialized[0]);

      final preKeyWhisperMessage =
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
          : const Optional.empty();
      signedPreKeyId = preKeyWhisperMessage.hasSignedPreKeyId()
          ? preKeyWhisperMessage.signedPreKeyId
          : -1;
      baseKey = Curve.decodePoint(
          Uint8List.fromList(preKeyWhisperMessage.baseKey), 0);
      identityKey = IdentityKey(Curve.decodePoint(
          Uint8List.fromList(preKeyWhisperMessage.identityKey), 0));
      message = SignalMessage.fromSerialized(
          Uint8List.fromList(preKeyWhisperMessage.message));
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    } on LegacyMessageException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
  }

  PreKeySignalMessage.from(this._version, this.registrationId, this.preKeyId,
      this.signedPreKeyId, this.baseKey, this.identityKey, this.message) {
    final builder = signal_protos.PreKeySignalMessage.create()
      ..signedPreKeyId = signedPreKeyId
      ..baseKey = baseKey.serialize()
      ..identityKey = identityKey.serialize()
      ..message = message.serialize()
      ..registrationId = registrationId;

    if (preKeyId.isPresent) {
      builder.preKeyId = preKeyId.value;
    }

    final versionBytes = [
      ByteUtil.intsToByteHighAndLow(_version, CiphertextMessage.currentVersion)
    ];

    final messageBytes = builder.toBuilder().writeToBuffer();
    serialized = Uint8List.fromList(versionBytes + messageBytes);
  }

  late int _version;
  late int registrationId;
  late Optional<int> preKeyId;
  late int signedPreKeyId;
  late ECPublicKey baseKey;
  late IdentityKey identityKey;
  late SignalMessage message;
  late Uint8List serialized;

  int getMessageVersion() => _version;

  IdentityKey getIdentityKey() => identityKey;

  int getRegistrationId() => registrationId;

  Optional<int> getPreKeyId() => preKeyId;

  int getSignedPreKeyId() => signedPreKeyId;

  ECPublicKey getBaseKey() => baseKey;

  SignalMessage getWhisperMessage() => message;

  @override
  int getType() => CiphertextMessage.prekeyType;

  @override
  Uint8List serialize() => serialized;
}

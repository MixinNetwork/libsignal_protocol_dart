import 'dart:typed_data';
import '../IdentityKey.dart';
import '../ecc/ECPublicKey.dart';

class PreKeyBundle {
  final int _registrationId;

  final int _deviceId;

  final int _preKeyId;
  final ECPublicKey _preKeyPublic;

  final int _signedPreKeyId;
  final ECPublicKey? _signedPreKeyPublic;
  final Uint8List? _signedPreKeySignature;

  final IdentityKey _identityKey;

  PreKeyBundle(
      this._registrationId,
      this._deviceId,
      this._preKeyId,
      this._preKeyPublic,
      this._signedPreKeyId,
      this._signedPreKeyPublic,
      this._signedPreKeySignature,
      this._identityKey);

  int getDeviceId() {
    return _deviceId;
  }

  int getPreKeyId() {
    return _preKeyId;
  }

  ECPublicKey getPreKey() {
    return _preKeyPublic;
  }

  int getSignedPreKeyId() {
    return _signedPreKeyId;
  }

  ECPublicKey? getSignedPreKey() {
    return _signedPreKeyPublic;
  }

  Uint8List? getSignedPreKeySignature() {
    return _signedPreKeySignature;
  }

  IdentityKey getIdentityKey() {
    return _identityKey;
  }

  int getRegistrationId() {
    return _registrationId;
  }
}

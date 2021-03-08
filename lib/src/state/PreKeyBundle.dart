import 'dart:typed_data';
import '../IdentityKey.dart';
import '../ecc/ECPublicKey.dart';

class PreKeyBundle {
  int _registrationId;

  int _deviceId;

  int _preKeyId;
  ECPublicKey _preKeyPublic;

  int _signedPreKeyId;
  ECPublicKey? _signedPreKeyPublic;
  Uint8List? _signedPreKeySignature;

  IdentityKey _identityKey;

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

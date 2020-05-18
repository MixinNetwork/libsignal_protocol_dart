import 'dart:typed_data';
import '../IdentityKey.dart';
import '../ecc/ECPublicKey.dart';

class PreKeyBundle {
  int _registrationId;

  int _deviceId;

  int _preKeyId;
  ECPublicKey _preKeyPublic;

  int _signedPreKeyId;
  ECPublicKey _signedPreKeyPublic;
  Uint8List _signedPreKeySignature;

  IdentityKey _identityKey;

  PreKeyBundle(
      int registrationId,
      int deviceId,
      int preKeyId,
      ECPublicKey preKeyPublic,
      int signedPreKeyId,
      ECPublicKey signedPreKeyPublic,
      Uint8List signedPreKeySignature,
      IdentityKey identityKey) {
    _registrationId = registrationId;
    _deviceId = deviceId;
    _preKeyId = preKeyId;
    _preKeyPublic = preKeyPublic;
    _signedPreKeyId = signedPreKeyId;
    _signedPreKeyPublic = signedPreKeyPublic;
    _signedPreKeySignature = signedPreKeySignature;
    _identityKey = identityKey;
  }

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

  ECPublicKey getSignedPreKey() {
    return _signedPreKeyPublic;
  }

  Uint8List getSignedPreKeySignature() {
    return _signedPreKeySignature;
  }

  IdentityKey getIdentityKey() {
    return _identityKey;
  }

  int getRegistrationId() {
    return _registrationId;
  }
}

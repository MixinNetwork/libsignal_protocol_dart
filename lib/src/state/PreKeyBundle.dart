import 'dart:typed_data';
import 'package:libsignalprotocoldart/src/IdentityKey.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';

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
    this._registrationId = registrationId;
    this._deviceId = deviceId;
    this._preKeyId = preKeyId;
    this._preKeyPublic = preKeyPublic;
    this._signedPreKeyId = signedPreKeyId;
    this._signedPreKeyPublic = signedPreKeyPublic;
    this._signedPreKeySignature = signedPreKeySignature;
    this._identityKey = identityKey;
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

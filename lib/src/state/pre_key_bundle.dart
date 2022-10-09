import 'dart:typed_data';

import '../ecc/ec_public_key.dart';
import '../identity_key.dart';

class PreKeyBundle {
  PreKeyBundle(
      this._registrationId,
      this._deviceId,
      this._preKeyId,
      this._preKeyPublic,
      this._signedPreKeyId,
      this._signedPreKeyPublic,
      this._signedPreKeySignature,
      this._identityKey);

  final int _registrationId;

  final int _deviceId;

  final int? _preKeyId;
  final ECPublicKey? _preKeyPublic;

  final int _signedPreKeyId;
  final ECPublicKey? _signedPreKeyPublic;
  final Uint8List? _signedPreKeySignature;

  final IdentityKey _identityKey;

  int getDeviceId() => _deviceId;

  int? getPreKeyId() => _preKeyId;

  ECPublicKey? getPreKey() => _preKeyPublic;

  int getSignedPreKeyId() => _signedPreKeyId;

  ECPublicKey? getSignedPreKey() => _signedPreKeyPublic;

  Uint8List? getSignedPreKeySignature() => _signedPreKeySignature;

  IdentityKey getIdentityKey() => _identityKey;

  int getRegistrationId() => _registrationId;
}

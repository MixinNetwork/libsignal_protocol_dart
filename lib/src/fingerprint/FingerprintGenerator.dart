import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/fingerprint/Fingerprint.dart';

import '../IdentityKey.dart';

abstract class FingerprintGenerator {
  Fingerprint createFor(
      int version,
      Uint8List localStableIdentifier,
      IdentityKey localIdentityKey,
      Uint8List remoteStableIdentifier,
      IdentityKey remoteIdentityKey
  );

  Fingerprint createListFor(
      int version,
      Uint8List localStableIdentifier,
      List<IdentityKey> localIdentityKey,
      Uint8List remoteStableIdentifier,
      List<IdentityKey> remoteIdentityKey
  );
}
import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/state/FingerprintProtocol.pb.dart';
import 'package:libsignalprotocoldart/src/util/ByteUtil.dart';

class ScannableFingerprint {
  int version;
  CombinedFingerprints fingerprints;

  ScannableFingerprint(int version, Uint8List localFingerprintData, Uint8List remoteFingerprintData) {
    LogicalFingerprint localFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(localFingerprintData, 32);

    LogicalFingerprint remoteFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(remoteFingerprintData, 32);

    this.version = version;
    fingerprints = CombinedFingerprints.create()
      ..version = version
      ..localFingerprint = localFingerprint
      ..remoteFingerprint;
  }
}
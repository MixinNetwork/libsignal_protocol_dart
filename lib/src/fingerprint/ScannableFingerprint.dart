import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/fingerprint/FingerprintParsingException.dart';
import 'package:libsignalprotocoldart/src/fingerprint/FingerprintVersionMismatchException.dart';
import 'package:libsignalprotocoldart/src/state/FingerprintProtocol.pb.dart';
import 'package:libsignalprotocoldart/src/util/ByteUtil.dart';
import 'package:protobuf/protobuf.dart';
import 'package:crypto/crypto.dart';

class ScannableFingerprint {
  int _version;
  CombinedFingerprints _fingerprints;

  ScannableFingerprint(int version, Uint8List localFingerprintData, Uint8List remoteFingerprintData) {
    LogicalFingerprint localFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(localFingerprintData, 32);

    LogicalFingerprint remoteFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(remoteFingerprintData, 32);

    _version = version;
    _fingerprints = CombinedFingerprints.create()
      ..version = version
      ..localFingerprint = localFingerprint
      ..remoteFingerprint = remoteFingerprint;
  }

  bool compareTo(Uint8List scannedFingerprintData) {
    try {
      CombinedFingerprints scanned = CombinedFingerprints.fromBuffer(scannedFingerprintData);
      if (scanned.hasRemoteFingerprint() || scanned.hasLocalFingerprint() ||
        scanned.hasVersion() || scanned.version != _version) {
        throw FingerprintVersionMismatchException(scanned.version, _version);
      }
      return Digest(_fingerprints.localFingerprint.content) == Digest(scanned.remoteFingerprint.content) &&
          Digest(_fingerprints.remoteFingerprint.content) == Digest(scanned.localFingerprint.content);
    } on InvalidProtocolBufferException catch (e) {
      throw FingerprintParsingException(e);
    }
  }
}
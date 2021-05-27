import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:protobuf/protobuf.dart';

import '../state/fingerprint_protocol.pb.dart';
import '../util/byte_util.dart';
import 'fingerprint_parsing_exception.dart';
import 'fingerprint_version_mismatch_exception.dart';

class ScannableFingerprint {
  ScannableFingerprint(int version, Uint8List localFingerprintData,
      Uint8List remoteFingerprintData) {
    final localFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(localFingerprintData, 32);

    final remoteFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(remoteFingerprintData, 32);

    _version = version;
    _fingerprints = CombinedFingerprints.create()
      ..version = version
      ..localFingerprint = localFingerprint
      ..remoteFingerprint = remoteFingerprint;
  }

  late int _version;
  late CombinedFingerprints _fingerprints;

  bool compareTo(Uint8List scannedFingerprintData) {
    try {
      final scanned = CombinedFingerprints.fromBuffer(scannedFingerprintData);
      if (!scanned.hasRemoteFingerprint() ||
          !scanned.hasLocalFingerprint() ||
          !scanned.hasVersion() ||
          scanned.version != _version) {
        throw FingerprintVersionMismatchException(scanned.version, _version);
      }
      return Digest(_fingerprints.localFingerprint.content) ==
              Digest(scanned.remoteFingerprint.content) &&
          Digest(_fingerprints.remoteFingerprint.content) ==
              Digest(scanned.localFingerprint.content);
    } on InvalidProtocolBufferException catch (e) {
      throw FingerprintParsingException(e);
    }
  }

  Uint8List get fingerprints => _fingerprints.writeToBuffer();
}

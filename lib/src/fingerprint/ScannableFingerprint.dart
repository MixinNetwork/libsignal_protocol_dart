import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';
import 'package:crypto/crypto.dart';

import 'FingerprintParsingException.dart';
import 'FingerprintVersionMismatchException.dart';
import '../state/FingerprintProtocol.pb.dart';
import '../util/ByteUtil.dart';

class ScannableFingerprint {
  late int _version;
  late CombinedFingerprints _fingerprints;

  ScannableFingerprint(int version, Uint8List localFingerprintData,
      Uint8List remoteFingerprintData) {
    var localFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(localFingerprintData, 32);

    var remoteFingerprint = LogicalFingerprint.create()
      ..content = ByteUtil.trim(remoteFingerprintData, 32);

    _version = version;
    _fingerprints = CombinedFingerprints.create()
      ..version = version
      ..localFingerprint = localFingerprint
      ..remoteFingerprint = remoteFingerprint;
  }

  bool compareTo(Uint8List scannedFingerprintData) {
    try {
      var scanned = CombinedFingerprints.fromBuffer(scannedFingerprintData);
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

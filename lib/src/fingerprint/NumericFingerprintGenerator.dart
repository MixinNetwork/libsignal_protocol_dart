import 'dart:typed_data';

import '../IdentityKey.dart';
import 'DisplayableFingerprint.dart';
import 'Fingerprint.dart';
import 'FingerprintGenerator.dart';
import 'package:crypto/crypto.dart';
import 'ScannableFingerprint.dart';
import '../util/ByteUtil.dart';
import '../util/IdentityKeyComparator.dart';

class NumericFingerprintGenerator implements FingerprintGenerator {
  static const int FINGERPRINT_VERSION = 0;

  int _iterations;

  NumericFingerprintGenerator(int iterations) {
    _iterations = iterations;
  }

  @override
  Fingerprint createFor(
      int version,
      Uint8List localStableIdentifier,
      IdentityKey localIdentityKey,
      Uint8List remoteStableIdentifier,
      IdentityKey remoteIdentityKey) {
    return createListFor(version, localStableIdentifier, [localIdentityKey],
        remoteStableIdentifier, [remoteIdentityKey]);
  }

  @override
  Fingerprint createListFor(
      int version,
      Uint8List localStableIdentifier,
      List<IdentityKey> localIdentityKey,
      Uint8List remoteStableIdentifier,
      List<IdentityKey> remoteIdentityKey) {
    var localFingerprint =
        _getFingerprint(_iterations, localStableIdentifier, localIdentityKey);
    var remoteFingerprint =
        _getFingerprint(_iterations, remoteStableIdentifier, remoteIdentityKey);
    var displayableFingerprint =
        DisplayableFingerprint(localFingerprint, remoteFingerprint);
    var scannableFingerprint =
        ScannableFingerprint(version, localFingerprint, remoteFingerprint);
    return Fingerprint(displayableFingerprint, scannableFingerprint);
  }

  Uint8List _getFingerprint(int iterations, Uint8List stableIdentifier,
      List<IdentityKey> unsortedIdentityKeys) {
    var publicKey = _getLogicalKeyBytes(unsortedIdentityKeys);
    var hash = ByteUtil.combine([
      ByteUtil.shortToByteArray(FINGERPRINT_VERSION),
      publicKey,
      stableIdentifier
    ]);
    for (var i = 0; i < iterations; i++) {
      hash = sha512.convert(hash).bytes;
    }
    return hash;
  }

  Uint8List _getLogicalKeyBytes(List<IdentityKey> identityKeys) {
    var sortedIdentityKeys = [...identityKeys];
    sortedIdentityKeys.sort(IdentityKeyComparator);

    var keys = [];
    sortedIdentityKeys.forEach((IdentityKey key) {
      var publicKeyBytes = key.publicKey.serialize();
      keys.addAll(publicKeyBytes.toList());
    });
    return Uint8List.fromList(keys);
  }
}

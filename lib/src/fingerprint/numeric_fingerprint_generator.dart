import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../identity_key.dart';
import '../util/byte_util.dart';
import '../util/identity_key_comparator.dart';
import 'displayable_fingerprint.dart';
import 'fingerprint.dart';
import 'fingerprint_generator.dart';
import 'scannable_fingerprint.dart';

class NumericFingerprintGenerator implements FingerprintGenerator {
  NumericFingerprintGenerator(this._iterations);

  static const int fingerprintVersion = 0;

  final int _iterations;

  @override
  Fingerprint createFor(
          int version,
          Uint8List localStableIdentifier,
          IdentityKey localIdentityKey,
          Uint8List remoteStableIdentifier,
          IdentityKey remoteIdentityKey) =>
      createListFor(version, localStableIdentifier, [localIdentityKey],
          remoteStableIdentifier, [remoteIdentityKey]);

  @override
  Fingerprint createListFor(
      int version,
      Uint8List localStableIdentifier,
      List<IdentityKey> localIdentityKey,
      Uint8List remoteStableIdentifier,
      List<IdentityKey> remoteIdentityKey) {
    final localFingerprint =
        _getFingerprint(_iterations, localStableIdentifier, localIdentityKey);
    final remoteFingerprint =
        _getFingerprint(_iterations, remoteStableIdentifier, remoteIdentityKey);
    final displayableFingerprint =
        DisplayableFingerprint(localFingerprint, remoteFingerprint);
    final scannableFingerprint =
        ScannableFingerprint(version, localFingerprint, remoteFingerprint);
    return Fingerprint(displayableFingerprint, scannableFingerprint);
  }

  Uint8List _getFingerprint(int iterations, Uint8List stableIdentifier,
      List<IdentityKey> unsortedIdentityKeys) {
    final publicKey = _getLogicalKeyBytes(unsortedIdentityKeys);
    var hash = ByteUtil.combine([
      ByteUtil.shortToByteArray(fingerprintVersion),
      publicKey,
      stableIdentifier
    ]);
    for (var i = 0; i < iterations; i++) {
      final output = AccumulatorSink<Digest>();
      sha512.startChunkedConversion(output)
        ..add(hash)
        ..add(publicKey)
        ..close();
      hash = Uint8List.fromList(output.events.single.bytes);
    }

    return hash;
  }

  Uint8List _getLogicalKeyBytes(List<IdentityKey> identityKeys) {
    final sortedIdentityKeys = [...identityKeys]..sort(identityKeyComparator);

    final keys = <int>[];
    sortedIdentityKeys.forEach((IdentityKey key) {
      final publicKeyBytes = key.publicKey.serialize();
      keys.addAll(publicKeyBytes.toList());
    });
    return Uint8List.fromList(keys);
  }
}

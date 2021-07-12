import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import '../invalid_key_exception.dart';
import 'hkdfv2.dart';
import 'hkdfv3.dart';

abstract class HKDF {
  static const int hashOutputSize = 32;

  static HKDF createFor(int messageVersion) {
    switch (messageVersion) {
      case 2:
        return HKDFv2();
      case 3:
        return HKDFv3();
      default:
        throw AssertionError('Unknown version: $messageVersion');
    }
  }

  Uint8List deriveSecrets(
      Uint8List inputKeyMaterial, Uint8List info, int outputLength) {
    final salt = Uint8List(hashOutputSize);
    return deriveSecrets4(inputKeyMaterial, salt, info, outputLength);
  }

  Uint8List deriveSecrets4(Uint8List inputKeyMaterial, Uint8List salt,
      Uint8List info, int outputLength) {
    final prk = extract(salt, inputKeyMaterial);
    return expand(prk, info, outputLength);
  }

  Uint8List extract(Uint8List salt, Uint8List inputKeyMaterial) {
    final hmacSha256 = Hmac(sha256, salt);
    final digest = hmacSha256.convert(inputKeyMaterial);
    return Uint8List.fromList(digest.bytes);
  }

  Uint8List expand(Uint8List prk, Uint8List? info, int outputSize) {
    try {
      final iterations =
          (outputSize.toDouble() / hashOutputSize.toDouble()).ceil();
      var mix = Uint8List(0);
      final results = Uint8List(outputSize);
      var remainingBytes = outputSize;

      for (var i = getIterationStartOffset();
          i < iterations + getIterationStartOffset();
          i++) {
        final mac = Hmac(sha256, prk);
        final output = AccumulatorSink<Digest>();
        final input = mac.startChunkedConversion(output)..add(mix);
        if (info != null) {
          input.add(info);
        }
        input
          ..add([i])
          ..close();
        final stepResult = Uint8List.fromList(output.events.single.bytes);
        final stepSize = min(remainingBytes, stepResult.length);

        for (var j = 0; j < stepSize; j++) {
          final offset = (i - getIterationStartOffset()) * hashOutputSize + j;
          results[offset] = stepResult[j];
        }

        mix = stepResult;
        remainingBytes -= stepSize;
      }
      return results.buffer.asUint8List();
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  int getIterationStartOffset();
}

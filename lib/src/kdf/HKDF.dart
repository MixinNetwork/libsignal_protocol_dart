import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import '../InvalidKeyException.dart';
import 'HKDFv2.dart';
import 'HKDFv3.dart';

abstract class HKDF {
  static final int HASH_OUTPUT_SIZE = 32;

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
    var salt = Uint8List(HASH_OUTPUT_SIZE);
    return deriveSecrets4(inputKeyMaterial, salt, info, outputLength);
  }

  Uint8List deriveSecrets4(Uint8List inputKeyMaterial, Uint8List salt,
      Uint8List info, int outputLength) {
    var prk = extract(salt, inputKeyMaterial);
    return expand(prk, info, outputLength);
  }

  Uint8List extract(Uint8List salt, Uint8List inputKeyMaterial) {
    var hmacSha256 = Hmac(sha256, salt);
    var digest = hmacSha256.convert(inputKeyMaterial);
    return Uint8List.fromList(digest.bytes);
  }

  Uint8List expand(Uint8List prk, Uint8List info, int outputSize) {
    try {
      var iterations =
          (outputSize.toDouble() / HASH_OUTPUT_SIZE.toDouble()).ceil();
      var mix = Uint8List(0);
      var results = Uint8List(outputSize);
      var remainingBytes = outputSize;

      for (var i = getIterationStartOffset();
          i < iterations + getIterationStartOffset();
          i++) {
        var mac = Hmac(sha256, prk);
        var output = AccumulatorSink<Digest>();
        var input = mac.startChunkedConversion(output);
        input.add(mix);
        if (info != null) {
          input.add(info);
        }
        input.add([i]);
        input.close();
        var stepResult = output.events.single.bytes;
        var stepSize = min(remainingBytes, stepResult.length);

        for (var j = 0; j < stepSize; j++) {
          var offset = (i - getIterationStartOffset()) * HASH_OUTPUT_SIZE + j;
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

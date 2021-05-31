import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import '../util/byte_util.dart';

import 'device_consistency_commitment.dart';
import 'device_consistency_signature.dart';

class DeviceConsistencyCodeGenerator {
  static const int codeVersion = 0;

  static String generateFor(DeviceConsistencyCommitment commitment,
      List<DeviceConsistencySignature> signatures) {
    final sortedSignatures = <DeviceConsistencySignature>[...signatures]
      ..sort(compareSignature);

    final output = AccumulatorSink<Digest>();
    final input = sha512.startChunkedConversion(output)
      ..add(ByteUtil.shortToByteArray(codeVersion))
      ..add(commitment.serialized);

    for (var signature in sortedSignatures) {
      input.add(signature.vrfOutput);
    }
    input.close();
    final hash = output.events.single.bytes;
    final digits = getEncodedChunk(Uint8List.fromList(hash), 0) +
        getEncodedChunk(Uint8List.fromList(hash), 5);
    return digits.substring(0, 6);
  }

  static String getEncodedChunk(Uint8List hash, int offset) {
    final chunk = ByteUtil.byteArray5ToLong(hash, offset).remainder(100000);
    return chunk.toString().padLeft(5, '0');
  }
}

int compareSignature(
        DeviceConsistencySignature a, DeviceConsistencySignature b) =>
    ByteUtil.compare(a.vrfOutput, b.vrfOutput);

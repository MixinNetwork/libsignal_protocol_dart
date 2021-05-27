import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import '../util/byte_util.dart';

import 'device_consistency_commitment.dart';
import 'device_consistency_signature.dart';

class DeviceConsistencyCodeGenerator {
  static const int CODE_VERSION = 0;

  static String generateFor(DeviceConsistencyCommitment commitment,
      List<DeviceConsistencySignature> signatures) {
    final sortedSignatures = <DeviceConsistencySignature>[...signatures]
      ..sort(SignatureComparator());

    final output = AccumulatorSink<Digest>();
    final input = sha512.startChunkedConversion(output)
      ..add(ByteUtil.shortToByteArray(CODE_VERSION))
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

Function SignatureComparator =
    (DeviceConsistencySignature a, DeviceConsistencySignature b) =>
        ByteUtil.compare(a.vrfOutput, b.vrfOutput);

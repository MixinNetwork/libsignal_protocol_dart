import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:libsignal_protocol_dart/src/util/ByteUtil.dart';

import 'DeviceConsistencyCommitment.dart';
import 'DeviceConsistencySignature.dart';

class DeviceConsistencyCodeGenerator {
  static const int CODE_VERSION = 0;

  static String generateFor(DeviceConsistencyCommitment commitment,
      List<DeviceConsistencySignature> signatures) {
    var sortedSignatures = <DeviceConsistencySignature>[];
    sortedSignatures.addAll(signatures);
    sortedSignatures.sort(SignatureComparator());

    var output = AccumulatorSink<Digest>();
    var input = sha512.startChunkedConversion(output);
    input.add(ByteUtil.shortToByteArray(CODE_VERSION));
    input.add(commitment.serialized);

    for (var signature in sortedSignatures) {
      input.add(signature.vrfOutput);
    }
    input.close();
    var hash = output.events.single.bytes;
    var digits = getEncodedChunk(hash, 0) + getEncodedChunk(hash, 5);
    return digits.substring(0, 6);
  }

  static String getEncodedChunk(Uint8List hash, int offset) {
    var chunk = ByteUtil.byteArray5ToLong(hash, offset) % 100000;
    return chunk.toString().padLeft(5, '0');
  }
}

Function SignatureComparator =
    (DeviceConsistencySignature a, DeviceConsistencySignature b) =>
        ByteUtil.compare(a.vrfOutput, b.vrfOutput);

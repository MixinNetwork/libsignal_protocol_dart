import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../IdentityKey.dart';
import '../util/ByteUtil.dart';

class DeviceConsistencyCommitment {
  static const String VERSION = 'DeviceConsistencyCommitment_V0';

  int _generation;
  Uint8List _serialized;

  DeviceConsistencyCommitment(int generation, List<IdentityKey> identityKeys) {
    var sortedIdentityKeys = <IdentityKey>[];
    sortedIdentityKeys.addAll(identityKeys);
    sortedIdentityKeys.sort((a, b) =>
        ByteUtil.compare(a.publicKey.serialize(), b.publicKey.serialize()));

    var output = AccumulatorSink<Digest>();
    var input = sha512.startChunkedConversion(output);
    input.add(utf8.encode(VERSION));
    input.add(ByteUtil.intToByteArray(generation));

    for (var commitment in sortedIdentityKeys) {
      input.add(commitment.publicKey.serialize());
    }
    input.close();

    _generation = generation;
    _serialized = output.events.single.bytes;
  }

  Uint8List get serialized => _serialized;

  int get generation => _generation;
}

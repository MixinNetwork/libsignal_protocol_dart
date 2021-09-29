import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../identity_key.dart';
import '../util/byte_util.dart';

class DeviceConsistencyCommitment {
  DeviceConsistencyCommitment(int generation, List<IdentityKey> identityKeys) {
    final sortedIdentityKeys = <IdentityKey>[...identityKeys]..sort((a, b) =>
        ByteUtil.compare(a.publicKey.serialize(), b.publicKey.serialize()));

    final output = AccumulatorSink<Digest>();
    final input = sha512.startChunkedConversion(output)
      ..add(utf8.encode(version))
      ..add(ByteUtil.intToByteArray(generation));

    for (final commitment in sortedIdentityKeys) {
      input.add(commitment.publicKey.serialize());
    }
    input.close();

    _generation = generation;
    _serialized = Uint8List.fromList(output.events.single.bytes);
  }

  static const String version = 'DeviceConsistencyCommitment_V0';

  late int _generation;
  late Uint8List _serialized;

  Uint8List get serialized => _serialized;

  int get generation => _generation;
}

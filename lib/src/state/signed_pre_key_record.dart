import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../invalid_key_exception.dart';
import 'local_storage_protocol.pb.dart';

class SignedPreKeyRecord {
  SignedPreKeyRecord(
      int id, Int64 timestamp, ECKeyPair keyPair, Uint8List signature) {
    _structure = SignedPreKeyRecordStructure.create()
      ..id = id
      ..timestamp = timestamp
      ..publicKey = keyPair.publicKey.serialize()
      ..privateKey = keyPair.privateKey.serialize()
      ..signature = signature;
  }

  SignedPreKeyRecord.fromSerialized(Uint8List serialized) {
    _structure = SignedPreKeyRecordStructure.fromBuffer(serialized);
  }

  late SignedPreKeyRecordStructure _structure;

  int get id => _structure.id;

  Int64 get timestamp => _structure.timestamp;

  ECKeyPair getKeyPair() {
    try {
      final publicKey = Curve.decodePointList(_structure.publicKey, 0);
      final privateKey =
          Curve.decodePrivatePoint(Uint8List.fromList(_structure.privateKey));

      return ECKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List get signature => Uint8List.fromList(_structure.signature);

  Uint8List serialize() => _structure.writeToBuffer();
}

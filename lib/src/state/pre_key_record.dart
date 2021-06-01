import 'dart:typed_data';
import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../invalid_key_exception.dart';
import 'local_storage_protocol.pb.dart';

class PreKeyRecord {
  PreKeyRecord(int id, ECKeyPair keyPair) {
    _structure = PreKeyRecordStructure.create()
      ..id = id
      ..publicKey = keyPair.publicKey.serialize()
      ..privateKey = keyPair.privateKey.serialize()
      ..toBuilder();
  }

  PreKeyRecord.fromBuffer(Uint8List serialized) {
    _structure = PreKeyRecordStructure.fromBuffer(serialized);
  }

  late PreKeyRecordStructure _structure;

  int get id => _structure.id;

  ECKeyPair getKeyPair() {
    try {
      final publicKey =
          Curve.decodePoint(Uint8List.fromList(_structure.publicKey), 0);
      final privateKey =
          Curve.decodePrivatePoint(Uint8List.fromList(_structure.privateKey));
      return ECKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List serialize() => _structure.writeToBuffer();
}

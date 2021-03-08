import 'dart:typed_data';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../InvalidKeyException.dart';
import 'LocalStorageProtocol.pb.dart';

class PreKeyRecord {
  late PreKeyRecordStructure _structure;

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

  int get id => _structure.id;

  ECKeyPair getKeyPair() {
    try {
      var publicKey =
          Curve.decodePoint(Uint8List.fromList(_structure.publicKey), 0);
      var privateKey =
          Curve.decodePrivatePoint(Uint8List.fromList(_structure.privateKey));
      return ECKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List serialize() {
    return _structure.writeToBuffer();
  }
}

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../InvalidKeyException.dart';
import 'LocalStorageProtocol.pb.dart';

class SignedPreKeyRecord {
  late SignedPreKeyRecordStructure _structure;

  SignedPreKeyRecord(
      int id, Int64 timestamp, ECKeyPair keyPair, Uint8List signature) {
    _structure = SignedPreKeyRecordStructure.create();
    _structure.id = id;
    _structure.timestamp = timestamp;
    _structure.publicKey = keyPair.publicKey.serialize();
    _structure.privateKey = keyPair.privateKey.serialize();
    _structure.signature = signature;
  }

  SignedPreKeyRecord.fromSerialized(Uint8List serialized) {
    _structure = SignedPreKeyRecordStructure.fromBuffer(serialized);
  }

  int get id => _structure.id;

  Int64 get timestamp => _structure.timestamp;

  ECKeyPair getKeyPair() {
    try {
      var publicKey = Curve.decodePointList(_structure.publicKey, 0);
      var privateKey =
          Curve.decodePrivatePoint(Uint8List.fromList(_structure.privateKey));

      return ECKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List get signature => Uint8List.fromList(_structure.signature);

  Uint8List serialize() {
    return _structure.writeToBuffer();
  }
}

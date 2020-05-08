import 'dart:typed_data';
import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPrivateKey.dart';
import '../ecc/ECPublicKey.dart';
import 'LocalStorageProtocol.pb.dart';

class PreKeyRecord {
  PreKeyRecordStructure _structure;

  PreKeyRecord(int id, ECKeyPair keyPair) {
    this._structure = PreKeyRecordStructure.create();
    this._structure.id = id;
    this._structure.publicKey = keyPair.getPublicKey().serialize();
    this._structure.privateKey = keyPair.getPrivateKey().serialize();
    this._structure.toBuilder();
  }

  PreKeyRecord.fromBuffer(Uint8List serialized) {
    this._structure = PreKeyRecordStructure.fromBuffer(serialized);
  }

  int getId() {
    return this._structure.id;
  }

  ECKeyPair getKeyPair() {
    // try {
    ECPublicKey publicKey = Curve.decodePoint(this._structure.publicKey, 0);
    ECPrivateKey privateKey =
        Curve.decodePrivatePoint(this._structure.privateKey);
    return new ECKeyPair(publicKey, privateKey);
    // } catch (InvalidKeyException e) {
    //   throw new AssertionError(e);
    // }
  }

  Uint8List serialize() {
    return this._structure.writeToBuffer();
  }
}

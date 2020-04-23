import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:libsignalprotocoldart/src/ecc/Curve.dart';

import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/state/LocalStorageProtocol.pb.dart';

class SignedPreKeyRecord {
  SignedPreKeyRecordStructure _structure;

  SignedPreKeyRecord(
      int id, Int64 timestamp, ECKeyPair keyPair, Uint8List signature) {
    this._structure = SignedPreKeyRecordStructure.create();
    this._structure.id = id;
    this._structure.timestamp = timestamp;
    this._structure.publicKey = keyPair.getPublicKey().serialize();
    this._structure.privateKey = keyPair.getPrivateKey().serialize();
    this._structure.signature = signature;
  }

  SignedPreKeyRecord.fromSerialized(Uint8List serialized) {
    this._structure = SignedPreKeyRecordStructure.fromBuffer(serialized);
  }

  int getId() {
    return this._structure.id;
  }

  Int64 getTimestamp() {
    return this._structure.timestamp;
  }

  ECKeyPair getKeyPair() {
    // try {
    var publicKey = Curve.decodePoint(this._structure.publicKey, 0);
    var privateKey = Curve.decodePrivatePoint(this._structure.privateKey);

    return ECKeyPair(publicKey, privateKey);
    // } catch (InvalidKeyException e) {
    //   throw new AssertionError(e);
    // }
  }

  Uint8List getSignature() {
    return this._structure.signature;
  }

  Uint8List serialize() {
    return this._structure.writeToBuffer();
  }
}

import 'dart:typed_data';

import 'IdentityKey.dart';
import 'ecc/ECPrivateKey.dart';

import 'ecc/Curve.dart';
import 'state/LocalStorageProtocol.pb.dart';

class IdentityKeyPair {
  IdentityKey _publicKey;
  ECPrivateKey _privateKey;

  IdentityKeyPair(this._publicKey, this._privateKey);

  IdentityKeyPair.fromSerialized(Uint8List serialized) {
    final structure = IdentityKeyPairStructure.fromBuffer(serialized);
    _publicKey =
        IdentityKey.fromBytes(Uint8List.fromList(structure.publicKey), 0);
    _privateKey =
        Curve.decodePrivatePoint(Uint8List.fromList(structure.privateKey));
  }

  IdentityKey getPublicKey() {
    return _publicKey;
  }

  ECPrivateKey getPrivateKey() {
    return _privateKey;
  }

  Uint8List serialize() {
    var i = IdentityKeyPairStructure.create();
    i.publicKey = List.from(_publicKey.serialize());
    i.privateKey = List.from(_privateKey.serialize());
    return i.toBuilder().writeToBuffer();
  }
}

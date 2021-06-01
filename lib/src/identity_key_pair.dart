import 'dart:typed_data';

import 'ecc/curve.dart';
import 'ecc/ec_private_key.dart';
import 'identity_key.dart';
import 'state/local_storage_protocol.pb.dart';

class IdentityKeyPair {
  IdentityKeyPair(this._publicKey, this._privateKey);

  IdentityKeyPair.fromSerialized(Uint8List serialized) {
    final structure = IdentityKeyPairStructure.fromBuffer(serialized);
    _publicKey =
        IdentityKey.fromBytes(Uint8List.fromList(structure.publicKey), 0);
    _privateKey =
        Curve.decodePrivatePoint(Uint8List.fromList(structure.privateKey));
  }

  late IdentityKey _publicKey;
  late ECPrivateKey _privateKey;

  IdentityKey getPublicKey() => _publicKey;

  ECPrivateKey getPrivateKey() => _privateKey;

  Uint8List serialize() {
    final i = IdentityKeyPairStructure.create()
      ..publicKey = List.from(_publicKey.serialize())
      ..privateKey = List.from(_privateKey.serialize());
    return i.toBuilder().writeToBuffer();
  }
}

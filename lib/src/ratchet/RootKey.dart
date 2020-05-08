import 'dart:convert';
import 'dart:typed_data';

import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPublicKey.dart';
import '../kdf/DerivedRootSecrets.dart';
import '../kdf/HKDF.dart';
import '../ratchet/ChainKey.dart';
import 'package:tuple/tuple.dart';

class RootKey {
  final HKDF _kdf;
  final Uint8List _key;

  RootKey(this._kdf, this._key) {}

  Uint8List getKeyBytes() {
    return _key;
  }

  Tuple2<RootKey, ChainKey> createChain(
      ECPublicKey theirRatchetKey, ECKeyPair ourRatchetKey) {
    Uint8List sharedSecret = Curve.calculateAgreement(
        theirRatchetKey, ourRatchetKey.getPrivateKey());
    List<int> bytes = utf8.encode("WhisperRatchet");
    Uint8List derivedSecretBytes =
        _kdf.deriveSecrets4(sharedSecret, _key, bytes, DerivedRootSecrets.SIZE);
    DerivedRootSecrets derivedSecrets =
        new DerivedRootSecrets(derivedSecretBytes);

    RootKey newRootKey = new RootKey(_kdf, derivedSecrets.getRootKey());
    ChainKey newChainKey = new ChainKey(_kdf, derivedSecrets.getChainKey(), 0);

    return Tuple2<RootKey, ChainKey>(newRootKey, newChainKey);
  }
}

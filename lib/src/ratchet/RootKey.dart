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

  RootKey(this._kdf, this._key);

  Uint8List getKeyBytes() {
    return _key;
  }

  Tuple2<RootKey, ChainKey> createChain(
      ECPublicKey theirRatchetKey, ECKeyPair ourRatchetKey) {
    var sharedSecret = Curve.calculateAgreement(
        theirRatchetKey, ourRatchetKey.privateKey);
    var bytes = utf8.encode('WhisperRatchet');
    var derivedSecretBytes =
        _kdf.deriveSecrets4(sharedSecret, _key, bytes, DerivedRootSecrets.SIZE);
    var derivedSecrets = DerivedRootSecrets(derivedSecretBytes);

    var newRootKey = RootKey(_kdf, derivedSecrets.getRootKey());
    var newChainKey = ChainKey(_kdf, derivedSecrets.getChainKey(), 0);

    return Tuple2<RootKey, ChainKey>(newRootKey, newChainKey);
  }
}

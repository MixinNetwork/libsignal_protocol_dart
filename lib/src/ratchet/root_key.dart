import 'dart:convert';
import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../kdf/derived_root_secrets.dart';
import '../kdf/hkdf.dart';
import '../ratchet/chain_key.dart';

class RootKey {
  RootKey(this._kdf, this._key);

  final HKDF _kdf;
  final Uint8List _key;

  Uint8List getKeyBytes() => _key;

  Tuple2<RootKey, ChainKey> createChain(
      ECPublicKey theirRatchetKey, ECKeyPair ourRatchetKey) {
    final sharedSecret =
        Curve.calculateAgreement(theirRatchetKey, ourRatchetKey.privateKey);
    final bytes = Uint8List.fromList(utf8.encode('WhisperRatchet'));
    final derivedSecretBytes =
        _kdf.deriveSecrets4(sharedSecret, _key, bytes, DerivedRootSecrets.size);
    final derivedSecrets = DerivedRootSecrets(derivedSecretBytes);

    final newRootKey = RootKey(_kdf, derivedSecrets.getRootKey());
    final newChainKey = ChainKey(_kdf, derivedSecrets.getChainKey(), 0);

    return Tuple2<RootKey, ChainKey>(newRootKey, newChainKey);
  }
}

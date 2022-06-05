import 'package:optional/optional.dart';

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class AliceSignalProtocolParameters {
  AliceSignalProtocolParameters({
    required this.ourIdentityKey,
    required this.ourBaseKey,
    required this.theirIdentityKey,
    required this.theirSignedPreKey,
    required this.theirRatchetKey,
    required this.theirOneTimePreKey,
  });

  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourBaseKey;

  final IdentityKey theirIdentityKey;
  final ECPublicKey theirSignedPreKey;
  final Optional<ECPublicKey> theirOneTimePreKey;
  final ECPublicKey theirRatchetKey;
}

import 'package:optional/optional.dart';

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class BobSignalProtocolParameters {
  BobSignalProtocolParameters({
    required this.ourIdentityKey,
    required this.ourSignedPreKey,
    required this.ourRatchetKey,
    required this.ourOneTimePreKey,
    required this.theirIdentityKey,
    required this.theirBaseKey,
  });

  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourSignedPreKey;
  final Optional<ECKeyPair> ourOneTimePreKey;
  final ECKeyPair ourRatchetKey;

  final IdentityKey theirIdentityKey;
  final ECPublicKey theirBaseKey;

  IdentityKeyPair getOurIdentityKey() => ourIdentityKey;

  ECKeyPair getOurSignedPreKey() => ourSignedPreKey;

  Optional<ECKeyPair> getOurOneTimePreKey() => ourOneTimePreKey;

  IdentityKey getTheirIdentityKey() => theirIdentityKey;

  ECPublicKey getTheirBaseKey() => theirBaseKey;

  ECKeyPair getOurRatchetKey() => ourRatchetKey;
}

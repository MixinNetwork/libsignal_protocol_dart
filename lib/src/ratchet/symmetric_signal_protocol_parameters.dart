import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class SymmetricSignalProtocolParameters {
  SymmetricSignalProtocolParameters({
    required this.ourBaseKey,
    required this.ourRatchetKey,
    required this.ourIdentityKey,
    required this.theirBaseKey,
    required this.theirRatchetKey,
    required this.theirIdentityKey,
  });

  final ECKeyPair ourBaseKey;
  final ECKeyPair ourRatchetKey;
  final IdentityKeyPair ourIdentityKey;

  final ECPublicKey theirBaseKey;
  final ECPublicKey theirRatchetKey;
  final IdentityKey theirIdentityKey;
}

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class SymmetricSignalProtocolParameters {
  SymmetricSignalProtocolParameters(
      this.ourBaseKey,
      this.ourRatchetKey,
      this.ourIdentityKey,
      this.theirBaseKey,
      this.theirRatchetKey,
      this.theirIdentityKey);

  final ECKeyPair ourBaseKey;
  final ECKeyPair ourRatchetKey;
  final IdentityKeyPair ourIdentityKey;

  final ECPublicKey theirBaseKey;
  final ECPublicKey theirRatchetKey;
  final IdentityKey theirIdentityKey;

  ECKeyPair getOurBaseKey() => ourBaseKey;

  ECKeyPair getOurRatchetKey() => ourRatchetKey;

  IdentityKeyPair getOurIdentityKey() => ourIdentityKey;

  ECPublicKey getTheirBaseKey() => theirBaseKey;

  ECPublicKey getTheirRatchetKey() => theirRatchetKey;

  IdentityKey getTheirIdentityKey() => theirIdentityKey;

  static Builder newBuilder() => Builder();
}

class Builder {
  late ECKeyPair ourBaseKey;
  late ECKeyPair ourRatchetKey;
  late IdentityKeyPair ourIdentityKey;

  late ECPublicKey theirBaseKey;
  late ECPublicKey theirRatchetKey;
  late IdentityKey theirIdentityKey;

  Builder setOurBaseKey(ECKeyPair ourBaseKey) {
    this.ourBaseKey = ourBaseKey;
    return this;
  }

  Builder setOurRatchetKey(ECKeyPair ourRatchetKey) {
    this.ourRatchetKey = ourRatchetKey;
    return this;
  }

  Builder setOurIdentityKey(IdentityKeyPair ourIdentityKey) {
    this.ourIdentityKey = ourIdentityKey;
    return this;
  }

  Builder setTheirBaseKey(ECPublicKey theirBaseKey) {
    this.theirBaseKey = theirBaseKey;
    return this;
  }

  Builder setTheirRatchetKey(ECPublicKey theirRatchetKey) {
    this.theirRatchetKey = theirRatchetKey;
    return this;
  }

  Builder setTheirIdentityKey(IdentityKey theirIdentityKey) {
    this.theirIdentityKey = theirIdentityKey;
    return this;
  }

  SymmetricSignalProtocolParameters create() =>
      SymmetricSignalProtocolParameters(ourBaseKey, ourRatchetKey,
          ourIdentityKey, theirBaseKey, theirRatchetKey, theirIdentityKey);
}

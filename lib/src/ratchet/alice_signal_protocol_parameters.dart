import 'package:optional/optional.dart';

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class AliceSignalProtocolParameters {
  AliceSignalProtocolParameters(
      this.ourIdentityKey,
      this.ourBaseKey,
      this.theirIdentityKey,
      this.theirSignedPreKey,
      this.theirRatchetKey,
      this.theirOneTimePreKey);

  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourBaseKey;

  final IdentityKey theirIdentityKey;
  final ECPublicKey theirSignedPreKey;
  final Optional<ECPublicKey> theirOneTimePreKey;
  final ECPublicKey theirRatchetKey;

  IdentityKeyPair getOurIdentityKey() => ourIdentityKey;

  ECKeyPair getOurBaseKey() => ourBaseKey;

  IdentityKey getTheirIdentityKey() => theirIdentityKey;

  ECPublicKey getTheirSignedPreKey() => theirSignedPreKey;

  Optional<ECPublicKey> getTheirOneTimePreKey() => theirOneTimePreKey;

  static Builder newBuilder() => Builder();

  ECPublicKey getTheirRatchetKey() => theirRatchetKey;
}

class Builder {
  late IdentityKeyPair ourIdentityKey;
  late ECKeyPair ourBaseKey;

  late IdentityKey theirIdentityKey;
  late ECPublicKey theirSignedPreKey;
  late ECPublicKey theirRatchetKey;
  late Optional<ECPublicKey> theirOneTimePreKey;

  Builder setOurIdentityKey(IdentityKeyPair ourIdentityKey) {
    this.ourIdentityKey = ourIdentityKey;
    return this;
  }

  Builder setOurBaseKey(ECKeyPair ourBaseKey) {
    this.ourBaseKey = ourBaseKey;
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

  Builder setTheirSignedPreKey(ECPublicKey theirSignedPreKey) {
    this.theirSignedPreKey = theirSignedPreKey;
    return this;
  }

  Builder setTheirOneTimePreKey(Optional<ECPublicKey> theirOneTimePreKey) {
    this.theirOneTimePreKey = theirOneTimePreKey;
    return this;
  }

  AliceSignalProtocolParameters create() => AliceSignalProtocolParameters(
      ourIdentityKey,
      ourBaseKey,
      theirIdentityKey,
      theirSignedPreKey,
      theirRatchetKey,
      theirOneTimePreKey);
}

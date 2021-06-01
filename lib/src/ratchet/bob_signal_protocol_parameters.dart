import 'package:optional/optional.dart';

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class BobSignalProtocolParameters {
  BobSignalProtocolParameters(
      this.ourIdentityKey,
      this.ourSignedPreKey,
      this.ourRatchetKey,
      this.ourOneTimePreKey,
      this.theirIdentityKey,
      this.theirBaseKey);

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

  static Builder newBuilder() => Builder();

  ECKeyPair getOurRatchetKey() => ourRatchetKey;
}

class Builder {
  late IdentityKeyPair ourIdentityKey;
  late ECKeyPair ourSignedPreKey;
  late Optional<ECKeyPair> ourOneTimePreKey;
  late ECKeyPair ourRatchetKey;

  late IdentityKey theirIdentityKey;
  late ECPublicKey theirBaseKey;

  Builder setOurIdentityKey(IdentityKeyPair ourIdentityKey) {
    this.ourIdentityKey = ourIdentityKey;
    return this;
  }

  Builder setOurSignedPreKey(ECKeyPair ourSignedPreKey) {
    this.ourSignedPreKey = ourSignedPreKey;
    return this;
  }

  Builder setOurOneTimePreKey(Optional<ECKeyPair> ourOneTimePreKey) {
    this.ourOneTimePreKey = ourOneTimePreKey;
    return this;
  }

  Builder setTheirIdentityKey(IdentityKey theirIdentityKey) {
    this.theirIdentityKey = theirIdentityKey;
    return this;
  }

  Builder setTheirBaseKey(ECPublicKey theirBaseKey) {
    this.theirBaseKey = theirBaseKey;
    return this;
  }

  Builder setOurRatchetKey(ECKeyPair ourRatchetKey) {
    this.ourRatchetKey = ourRatchetKey;
    return this;
  }

  BobSignalProtocolParameters create() => BobSignalProtocolParameters(
      ourIdentityKey,
      ourSignedPreKey,
      ourRatchetKey,
      ourOneTimePreKey,
      theirIdentityKey,
      theirBaseKey);
}

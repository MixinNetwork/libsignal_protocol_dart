import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPublicKey.dart';
import 'package:optional/optional.dart';

class BobSignalProtocolParameters {
  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourSignedPreKey;
  final Optional<ECKeyPair> ourOneTimePreKey;
  final ECKeyPair ourRatchetKey;

  final IdentityKey theirIdentityKey;
  final ECPublicKey theirBaseKey;

  BobSignalProtocolParameters(
      this.ourIdentityKey,
      this.ourSignedPreKey,
      this.ourRatchetKey,
      this.ourOneTimePreKey,
      this.theirIdentityKey,
      this.theirBaseKey) {
    if (ourIdentityKey == null ||
        ourSignedPreKey == null ||
        ourRatchetKey == null ||
        ourOneTimePreKey == null ||
        theirIdentityKey == null ||
        theirBaseKey == null) {
      throw ("Null value!");
    }
  }

  IdentityKeyPair getOurIdentityKey() {
    return ourIdentityKey;
  }

  ECKeyPair getOurSignedPreKey() {
    return ourSignedPreKey;
  }

  Optional<ECKeyPair> getOurOneTimePreKey() {
    return ourOneTimePreKey;
  }

  IdentityKey getTheirIdentityKey() {
    return theirIdentityKey;
  }

  ECPublicKey getTheirBaseKey() {
    return theirBaseKey;
  }

  static Builder newBuilder() {
    return Builder();
  }

  ECKeyPair getOurRatchetKey() {
    return ourRatchetKey;
  }
}

class Builder {
  IdentityKeyPair ourIdentityKey;
  ECKeyPair ourSignedPreKey;
  Optional<ECKeyPair> ourOneTimePreKey;
  ECKeyPair ourRatchetKey;

  IdentityKey theirIdentityKey;
  ECPublicKey theirBaseKey;

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

  BobSignalProtocolParameters create() {
    return new BobSignalProtocolParameters(ourIdentityKey, ourSignedPreKey,
        ourRatchetKey, ourOneTimePreKey, theirIdentityKey, theirBaseKey);
  }
}

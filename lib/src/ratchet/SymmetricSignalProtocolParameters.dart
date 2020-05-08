import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPublicKey.dart';

class SymmetricSignalProtocolParameters {
  final ECKeyPair ourBaseKey;
  final ECKeyPair ourRatchetKey;
  final IdentityKeyPair ourIdentityKey;

  final ECPublicKey theirBaseKey;
  final ECPublicKey theirRatchetKey;
  final IdentityKey theirIdentityKey;

  SymmetricSignalProtocolParameters(
      this.ourBaseKey,
      this.ourRatchetKey,
      this.ourIdentityKey,
      this.theirBaseKey,
      this.theirRatchetKey,
      this.theirIdentityKey) {
    if (ourBaseKey == null ||
        ourRatchetKey == null ||
        ourIdentityKey == null ||
        theirBaseKey == null ||
        theirRatchetKey == null ||
        theirIdentityKey == null) {
      throw ("Null values!");
    }
  }

  ECKeyPair getOurBaseKey() {
    return ourBaseKey;
  }

  ECKeyPair getOurRatchetKey() {
    return ourRatchetKey;
  }

  IdentityKeyPair getOurIdentityKey() {
    return ourIdentityKey;
  }

  ECPublicKey getTheirBaseKey() {
    return theirBaseKey;
  }

  ECPublicKey getTheirRatchetKey() {
    return theirRatchetKey;
  }

  IdentityKey getTheirIdentityKey() {
    return theirIdentityKey;
  }

  static Builder newBuilder() {
    return new Builder();
  }
}

class Builder {
  ECKeyPair ourBaseKey;
  ECKeyPair ourRatchetKey;
  IdentityKeyPair ourIdentityKey;

  ECPublicKey theirBaseKey;
  ECPublicKey theirRatchetKey;
  IdentityKey theirIdentityKey;

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

  SymmetricSignalProtocolParameters create() {
    return new SymmetricSignalProtocolParameters(ourBaseKey, ourRatchetKey,
        ourIdentityKey, theirBaseKey, theirRatchetKey, theirIdentityKey);
  }
}

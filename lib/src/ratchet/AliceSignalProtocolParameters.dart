import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPublicKey.dart';
import 'package:optional/optional.dart';

class AliceSignalProtocolParameters {
  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourBaseKey;

  final IdentityKey theirIdentityKey;
  final ECPublicKey theirSignedPreKey;
  final Optional<ECPublicKey> theirOneTimePreKey;
  final ECPublicKey theirRatchetKey;

  AliceSignalProtocolParameters(
      this.ourIdentityKey,
      this.ourBaseKey,
      this.theirIdentityKey,
      this.theirSignedPreKey,
      this.theirRatchetKey,
      this.theirOneTimePreKey) {
    if (ourIdentityKey == null ||
        ourBaseKey == null ||
        theirIdentityKey == null ||
        theirSignedPreKey == null ||
        theirRatchetKey == null ||
        theirOneTimePreKey == null) {
      throw ('Null values!');
    }
  }

  IdentityKeyPair getOurIdentityKey() {
    return ourIdentityKey;
  }

  ECKeyPair getOurBaseKey() {
    return ourBaseKey;
  }

  IdentityKey getTheirIdentityKey() {
    return theirIdentityKey;
  }

  ECPublicKey getTheirSignedPreKey() {
    return theirSignedPreKey;
  }

  Optional<ECPublicKey> getTheirOneTimePreKey() {
    return theirOneTimePreKey;
  }

  static Builder newBuilder() {
    return Builder();
  }

  ECPublicKey getTheirRatchetKey() {
    return theirRatchetKey;
  }
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

  AliceSignalProtocolParameters create() {
    return AliceSignalProtocolParameters(
        ourIdentityKey,
        ourBaseKey,
        theirIdentityKey,
        theirSignedPreKey,
        theirRatchetKey,
        theirOneTimePreKey);
  }
}

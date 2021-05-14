import 'dart:collection';

import '../../IdentityKey.dart';
import '../../IdentityKeyPair.dart';
import '../../SignalProtocolAddress.dart';
import '../../eq.dart';
import '../IdentityKeyStore.dart';

class InMemoryIdentityKeyStore extends IdentityKeyStore {
  final trustedKeys = HashMap<SignalProtocolAddress, IdentityKey>();

  final IdentityKeyPair identityKeyPair;
  final int localRegistrationId;

  InMemoryIdentityKeyStore(this.identityKeyPair, this.localRegistrationId);

  @override
  Future<IdentityKey> getIdentity(SignalProtocolAddress address) async {
    return trustedKeys[address]!;
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    return identityKeyPair;
  }

  @override
  Future<int> getLocalRegistrationId() async {
    return localRegistrationId;
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction? direction) async {
    var trusted = trustedKeys[address];
    if (identityKey == null) {
      return false;
    }
    return (trusted == null ||
        eq(trusted.serialize(), identityKey.serialize()));
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    var existing = trustedKeys[address];
    if (identityKey == null) {
      return false;
    }
    if (identityKey != existing) {
      trustedKeys[address] = identityKey;
      return true;
    } else {
      return false;
    }
  }
}

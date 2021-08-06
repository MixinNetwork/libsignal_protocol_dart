import 'dart:collection';

import '../../eq.dart';
import '../../identity_key.dart';
import '../../identity_key_pair.dart';
import '../../signal_protocol_address.dart';
import '../identity_key_store.dart';

class InMemoryIdentityKeyStore extends IdentityKeyStore {
  InMemoryIdentityKeyStore(this.identityKeyPair, this.localRegistrationId);

  final trustedKeys = HashMap<SignalProtocolAddress, IdentityKey>();

  final IdentityKeyPair identityKeyPair;
  final int localRegistrationId;

  @override
  Future<IdentityKey> getIdentity(SignalProtocolAddress address) async =>
      trustedKeys[address]!;

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async => identityKeyPair;

  @override
  Future<int> getLocalRegistrationId() async => localRegistrationId;

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction? direction) async {
    final trusted = trustedKeys[address];
    if (identityKey == null) {
      return false;
    }
    return trusted == null || eq(trusted.serialize(), identityKey.serialize());
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    final existing = trustedKeys[address];
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

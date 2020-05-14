import 'dart:collection';

import '../../IdentityKey.dart';
import '../../IdentityKeyPair.dart';
import '../../SignalProtocolAddress.dart';
import '../IdentityKeyStore.dart';

class InMemoryIdentityKeyStore extends IdentityKeyStore {
  final trustedKeys = HashMap<SignalProtocolAddress, IdentityKey>();

  final IdentityKeyPair identityKeyPair;
  final int localRegistrationId;

  InMemoryIdentityKeyStore(this.identityKeyPair, this.localRegistrationId);

  @override
  IdentityKey getIdentity(SignalProtocolAddress address) {
    return trustedKeys[address];
  }

  @override
  IdentityKeyPair getIdentityKeyPair() {
    return identityKeyPair;
  }

  @override
  int getLocalRegistrationId() {
    return localRegistrationId;
  }

  @override
  bool isTrustedIdentity(SignalProtocolAddress address, IdentityKey identityKey,
      Direction direction) {
    var trusted = trustedKeys[address];
    return (trusted == null || trusted == identityKey);
  }

  @override
  bool saveIdentity(SignalProtocolAddress address, IdentityKey identityKey) {
    var existing = trustedKeys[address];
    if (identityKey != existing) {
      trustedKeys[address] = identityKey;
      return true;
    } else {
      return false;
    }
  }
}

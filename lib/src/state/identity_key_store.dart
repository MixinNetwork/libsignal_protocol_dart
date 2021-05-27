import '../identity_key.dart';
import '../identity_key_pair.dart';
import '../signal_protocol_address.dart';

enum Direction { SENDING, RECEIVING }

abstract class IdentityKeyStore {
  Future<IdentityKeyPair> getIdentityKeyPair();
  Future<int> getLocalRegistrationId();
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey);
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction);
  Future<IdentityKey> getIdentity(SignalProtocolAddress address);
}

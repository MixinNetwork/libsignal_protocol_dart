import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../SignalProtocolAddress.dart';

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

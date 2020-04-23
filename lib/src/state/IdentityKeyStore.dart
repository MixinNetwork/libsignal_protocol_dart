import 'package:libsignalprotocoldart/src/IdentityKey.dart';
import 'package:libsignalprotocoldart/src/IdentityKeyPair.dart';
import 'package:libsignalprotocoldart/src/SignalProtocolAddress.dart';

enum Direction { SENDING, RECEIVING }

abstract class IdentityKeyStore {
  IdentityKeyPair getIdentityKeyPair();
  int getLocalRegistrationId();
  bool saveIdentity(SignalProtocolAddress address, IdentityKey identityKey);
  bool isTrustedIdentity(SignalProtocolAddress address, IdentityKey identityKey,
      Direction direction);
  IdentityKey getIdentity(SignalProtocolAddress address);
}

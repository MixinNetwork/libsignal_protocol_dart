import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/state/impl/in_memory_signal_protocol_store.dart';
import 'package:libsignal_protocol_dart/src/util/key_helper.dart';

class TestInMemorySignalProtocolStore extends InMemorySignalProtocolStore {
  TestInMemorySignalProtocolStore()
      : super(_generateIdentityKeyPair(), _generateRegistrationId());

  static IdentityKeyPair _generateIdentityKeyPair() {
    final identityKeyPairKeys = Curve.generateKeyPair();

    return IdentityKeyPair(IdentityKey(identityKeyPairKeys.publicKey),
        identityKeyPairKeys.privateKey);
  }

  static int _generateRegistrationId() => generateRegistrationId(false);
}

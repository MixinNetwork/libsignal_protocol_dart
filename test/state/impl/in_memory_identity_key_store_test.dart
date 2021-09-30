import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/impl/in_memory_identity_key_store.dart';
import 'package:libsignal_protocol_dart/src/util/key_helper.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () async {
    final keyPair = Curve.generateKeyPair();
    final identityKey = IdentityKey(keyPair.publicKey);
    final identityKeyPair = IdentityKeyPair(identityKey, keyPair.privateKey);
    final registrationId = generateRegistrationId(false);
    final store = InMemoryIdentityKeyStore(identityKeyPair, registrationId);
    const address = SignalProtocolAddress('address-1', 123);

    // getIdentityKeyPair
    expect(await store.getIdentityKeyPair(), identityKeyPair);

    // getLocalRegistrationId
    expect(await store.getLocalRegistrationId(), registrationId);

    // getIdentity
    // TODO
    // expect(store.getIdentity(address), null);

    // saveIdentity & getIdentity
    expect(await store.saveIdentity(address, identityKey), true);
    expect(
      await store.getIdentity(address).then((value) => value.getFingerprint()),
      identityKey.getFingerprint(),
    );
    expect(await store.saveIdentity(address, identityKey), false);

    // isTrustedIdentity
    expect(await store.isTrustedIdentity(address, identityKey, null), true);
    // expect(store.isTrustedIdentity(null, identityKey, null), true);
    final newIdentityKey = IdentityKey(Curve.generateKeyPair().publicKey);
    expect(await store.isTrustedIdentity(address, newIdentityKey, null), false);
  });
}

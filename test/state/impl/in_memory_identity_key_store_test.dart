import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:libsignal_protocol_dart/src/IdentityKeyPair.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () {
    final keyPair = Curve.generateKeyPair();
    final identityKey = IdentityKey(keyPair.publicKey);
    final identityKeyPair = IdentityKeyPair(identityKey, keyPair.privateKey);
    final registrationId = KeyHelper.generateRegistrationId(false);
    final store = InMemoryIdentityKeyStore(identityKeyPair, registrationId);
    final address = SignalProtocolAddress('address-1', 123);

    // getIdentityKeyPair
    expect(store.getIdentityKeyPair(), identityKeyPair);

    // getLocalRegistrationId
    expect(store.getLocalRegistrationId(), registrationId);

    // getIdentity
    // TODO
    // expect(store.getIdentity(address), null);

    // saveIdentity & getIdentity
    expect(store.saveIdentity(address, identityKey), true);
    expect(
      store.getIdentity(address).getFingerprint(),
      identityKey.getFingerprint(),
    );
    expect(store.saveIdentity(address, identityKey), false);

    // isTrustedIdentity
    expect(store.isTrustedIdentity(address, identityKey, null), true);
    // expect(store.isTrustedIdentity(null, identityKey, null), true);
    var newIdentityKey = IdentityKey(Curve.generateKeyPair().publicKey);
    expect(store.isTrustedIdentity(address, newIdentityKey, null), false);
  });
}

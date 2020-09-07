import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () {
    final store = InMemorySignedPreKeyStore();
    final signedPreKeyRecord1 = _generateSignedPreKey(1);
    final signedPreKeyRecord2 = _generateSignedPreKey(2);

    // storeSignedPreKey
    store.storeSignedPreKey(1, signedPreKeyRecord1);
    store.storeSignedPreKey(2, signedPreKeyRecord2);

    // containsSignedPreKey
    expect(store.containsSignedPreKey(1), true);
    expect(store.containsSignedPreKey(2), true);
    expect(store.containsSignedPreKey(3), false);

    // loadSignedPreKey
    expect(store.loadSignedPreKey(1).id, 1);
    expect(store.loadSignedPreKey(2).id, 2);

    // loadSignedPreKey
    expect(() => store.loadSignedPreKey(10),
        throwsA(isA<InvalidKeyIdException>()));

    // loadSignedPreKeys
    final signedPreKeys = store.loadSignedPreKeys();
    expect(signedPreKeys.length, 2);
    expect(signedPreKeys[0].id, 1);
    expect(signedPreKeys[1].id, 2);

    // removeSignedPreKey & containsSignedPreKey
    store.removeSignedPreKey(1);
    expect(store.containsSignedPreKey(1), false);
    expect(store.containsSignedPreKey(2), true);
  });
}

SignedPreKeyRecord _generateSignedPreKey(int signedPreKeyId) =>
    KeyHelper.generateSignedPreKey(
        KeyHelper.generateIdentityKeyPair(), signedPreKeyId);

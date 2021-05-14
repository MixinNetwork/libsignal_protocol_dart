import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () async {
    final store = InMemorySignedPreKeyStore();
    final signedPreKeyRecord1 = _generateSignedPreKey(1);
    final signedPreKeyRecord2 = _generateSignedPreKey(2);

    // storeSignedPreKey
    store.storeSignedPreKey(1, signedPreKeyRecord1);
    store.storeSignedPreKey(2, signedPreKeyRecord2);

    // containsSignedPreKey
    expect(await store.containsSignedPreKey(1), true);
    expect(await store.containsSignedPreKey(2), true);
    expect(await store.containsSignedPreKey(3), false);

    // loadSignedPreKey
    expect(await store.loadSignedPreKey(1).then((value) => value.id), 1);
    expect(await store.loadSignedPreKey(2).then((value) => value.id), 2);

    // loadSignedPreKey
    expect(() => store.loadSignedPreKey(10),
        throwsA(isA<InvalidKeyIdException>()));

    // loadSignedPreKeys
    final signedPreKeys = await store.loadSignedPreKeys();
    expect(signedPreKeys.length, 2);
    expect(signedPreKeys[0].id, 1);
    expect(signedPreKeys[1].id, 2);

    // removeSignedPreKey & containsSignedPreKey
    store.removeSignedPreKey(1);
    expect(await store.containsSignedPreKey(1), false);
    expect(await store.containsSignedPreKey(2), true);
  });
}

SignedPreKeyRecord _generateSignedPreKey(int signedPreKeyId) =>
    KeyHelper.generateSignedPreKey(
        KeyHelper.generateIdentityKeyPair(), signedPreKeyId);

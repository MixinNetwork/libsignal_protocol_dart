import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () async {
    final store = InMemoryPreKeyStore();
    final preKeys = generatePreKeys(1, 2);

    // storePreKey
    await store.storePreKey(1, preKeys[0]);
    await store.storePreKey(2, preKeys[1]);

    // containsPreKey
    expect(await store.containsPreKey(1), true);
    expect(await store.containsPreKey(2), true);
    expect(await store.containsPreKey(3), false);

    // loadPreKey
    expect(await store.loadPreKey(2).then((value) => value.serialize()),
        preKeys[1].serialize());

    // removePreKey & loadPreKey
    await store.removePreKey(2);
    expect(() => store.loadPreKey(2), throwsA(isA<InvalidKeyIdException>()));
  });
}

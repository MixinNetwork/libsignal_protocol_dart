import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () {
    final store = InMemoryPreKeyStore();
    var preKeys = KeyHelper.generatePreKeys(1, 2);

    // storePreKey
    store.storePreKey(1, preKeys[0]);
    store.storePreKey(2, preKeys[1]);

    // containsPreKey
    expect(store.containsPreKey(1), true);
    expect(store.containsPreKey(2), true);
    expect(store.containsPreKey(3), false);

    // loadPreKey
    expect(store.loadPreKey(2).serialize(), preKeys[1].serialize());

    // removePreKey & loadPreKey
    store.removePreKey(2);
    expect(() => store.loadPreKey(2), throwsA(isA<InvalidKeyIdException>()));
  });
}

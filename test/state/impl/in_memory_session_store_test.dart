import 'package:collection/collection.dart';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should implement interface successfully', () async {
    final address1 = SignalProtocolAddress('address-1', 123);
    final address2a = SignalProtocolAddress('address-2', 123);
    final address2b = SignalProtocolAddress('address-2', 456);
    final store = InMemorySessionStore();

    // containsSession & loadSession
    expect(await store.containsSession(address1), false);
    final sessionRecord1 = await store.loadSession(address1);
    await store.storeSession(address1, sessionRecord1);
    expect(await store.containsSession(address1), true);

    // loadSession & storeSession
    final sessionRecord2 = await store.loadSession(address1);
    await store.storeSession(address2a, sessionRecord2);
    await store.storeSession(address2b, sessionRecord2);

    // getSubDeviceSessions
    final subDeviceSessions1 =
        await store.getSubDeviceSessions(address1.getName());
    expect(subDeviceSessions1.length, 1);
    expect(subDeviceSessions1, [123]);
    final subDeviceSessions2 =
        await store.getSubDeviceSessions(address2a.getName());
    expect(subDeviceSessions2.length, 2);
    expect(
        SetEquality().equals(
          subDeviceSessions2.toSet(),
          {123, 456}.toSet(),
        ),
        true);

    // deleteSession & containsSession
    expect(await store.containsSession(address2a), true);
    await store.deleteSession(address2a);
    expect(await store.containsSession(address2a), false);

    // deleteAllSessions & containsSession
    expect(await store.containsSession(address2b), true);
    await store.deleteAllSessions(address2b.getName());
    expect(await store.containsSession(address2b), false);
  });
}

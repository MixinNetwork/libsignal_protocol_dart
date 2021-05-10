import '../SignalProtocolAddress.dart';

import 'SessionRecord.dart';

abstract class SessionStore {
  Future<SessionRecord> loadSession(SignalProtocolAddress address);

  Future<List<int>> getSubDeviceSessions(String name);

  Future storeSession(SignalProtocolAddress address, SessionRecord record);

  Future<bool> containsSession(SignalProtocolAddress address);

  Future deleteSession(SignalProtocolAddress address);

  Future deleteAllSessions(String name);
}

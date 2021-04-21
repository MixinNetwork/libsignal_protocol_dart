import '../SignalProtocolAddress.dart';

import 'SessionRecord.dart';

abstract class SessionStore {
  Future<SessionRecord> loadSession(SignalProtocolAddress address);

  Future<List<int>> getSubDeviceSessions(String name);

  void storeSession(SignalProtocolAddress address, SessionRecord record);

  Future<bool> containsSession(SignalProtocolAddress address);

  void deleteSession(SignalProtocolAddress address);

  void deleteAllSessions(String name);
}

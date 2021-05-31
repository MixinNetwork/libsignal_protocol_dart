import '../signal_protocol_address.dart';

import 'session_record.dart';

abstract class SessionStore {
  Future<SessionRecord> loadSession(SignalProtocolAddress address);

  Future<List<int>> getSubDeviceSessions(String name);

  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record);

  Future<bool> containsSession(SignalProtocolAddress address);

  Future<void> deleteSession(SignalProtocolAddress address);

  Future<void> deleteAllSessions(String name);
}

import '../SignalProtocolAddress.dart';

import 'SessionRecord.dart';

abstract class SessionStore {
  SessionRecord loadSession(SignalProtocolAddress address);

  List<int> getSubDeviceSessions(String name);

  void storeSession(SignalProtocolAddress address, SessionRecord record);

  bool containsSession(SignalProtocolAddress address);

  void deleteSession(SignalProtocolAddress address);

  void deleteAllSessions(String name);
}

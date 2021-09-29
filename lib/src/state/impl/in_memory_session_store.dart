import 'dart:collection';
import 'dart:typed_data';

import '../../signal_protocol_address.dart';
import '../session_record.dart';
import '../session_store.dart';

class InMemorySessionStore extends SessionStore {
  InMemorySessionStore();

  HashMap<SignalProtocolAddress, Uint8List> sessions =
      HashMap<SignalProtocolAddress, Uint8List>();

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async =>
      sessions.containsKey(address);

  @override
  Future<void> deleteAllSessions(String name) async {
    for (final k in sessions.keys.toList()) {
      if (k.getName() == name) {
        sessions.remove(k);
      }
    }
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    sessions.remove(address);
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final deviceIds = <int>[];

    for (final key in sessions.keys) {
      if (key.getName() == name && key.getDeviceId() != 1) {
        deviceIds.add(key.getDeviceId());
      }
    }

    return deviceIds;
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    try {
      if (await containsSession(address)) {
        return SessionRecord.fromSerialized(sessions[address]!);
      } else {
        return SessionRecord();
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    sessions[address] = record.serialize();
  }
}

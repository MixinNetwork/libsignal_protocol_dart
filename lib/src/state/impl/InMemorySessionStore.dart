import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/state/SessionRecord.dart';

import '../../SignalProtocolAddress.dart';
import '../SessionStore.dart';

class InMemorySessionStore extends SessionStore {
  var sessions = HashMap<SignalProtocolAddress, Uint8List>();

  InMemorySessionStore();

  @override
  bool containsSession(SignalProtocolAddress address) {
    return sessions.containsKey(address);
  }

  @override
  void deleteAllSessions(String name) {
    for (var k in sessions.keys.toList()) {
      if (k.getName() == name) {
        sessions.remove(k);
      }
    }
  }

  @override
  void deleteSession(SignalProtocolAddress address) {
    sessions.remove(address);
  }

  @override
  List<int> getSubDeviceSessions(String name) {
    var deviceIds = List<int>();

    for (var key in sessions.keys) {
      if (key.getName() == name && key.getDeviceId() != 1) {
        deviceIds.add(key.getDeviceId());
      }
    }

    return deviceIds;
  }

  @override
  SessionRecord loadSession(SignalProtocolAddress remoteAddress) {
    try {
      if (containsSession(remoteAddress)) {
        return SessionRecord.fromSerialized(sessions[remoteAddress]);
      } else {
        return SessionRecord();
      }
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  void storeSession(SignalProtocolAddress address, SessionRecord record) {
    sessions[address] = record.serialize();
  }
}

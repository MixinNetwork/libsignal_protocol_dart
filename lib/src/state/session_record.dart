import 'dart:collection';
import 'dart:typed_data';

import '../eq.dart';
import 'local_storage_protocol.pb.dart';
import 'session_state.dart';

class SessionRecord {
  SessionRecord() {
    _fresh = true;
  }

  SessionRecord.fromSessionState(SessionState sessionState) {
    _sessionState = sessionState;
    _fresh = false;
  }

  SessionRecord.fromSerialized(Uint8List serialized) {
    final record = RecordStructure.fromBuffer(serialized);
    _sessionState = SessionState.fromStructure(record.currentSession);
    _fresh = false;

    for (var previousStructure in record.previousSessions) {
      _previousStates.add(SessionState.fromStructure(previousStructure));
    }
  }

  static const int archivedStatesMaxLength = 40;
  var _sessionState = SessionState();
  final _previousStates = LinkedList<SessionState>();
  bool _fresh = false;

  bool hasSessionState(int version, Uint8List aliceBaseKey) {
    if (_sessionState.getSessionVersion() == version &&
        // ignore: avoid_dynamic_calls
        eq(aliceBaseKey, _sessionState.aliceBaseKey)) {
      return true;
    }

    for (var state in _previousStates) {
      if (state.getSessionVersion() == version &&
          // ignore: avoid_dynamic_calls
          eq(aliceBaseKey, _sessionState.aliceBaseKey)) {
        return true;
      }
    }
    return false;
  }

  SessionState get sessionState => _sessionState;

  LinkedList<SessionState> get previousSessionStates => _previousStates;

  void removePreviousSessionStates() {
    _previousStates.clear();
  }

  bool isFresh() => _fresh;

  void archiveCurrentState() {
    promoteState(SessionState());
  }

  void promoteState(SessionState promotedState) {
    _previousStates.addFirst(_sessionState);
    _sessionState = promotedState;

    if (_previousStates.length > archivedStatesMaxLength) {
      _previousStates.remove(_previousStates.last);
    }
  }

  set state(SessionState sessionState) {
    _sessionState = sessionState;
  }

  Uint8List serialize() {
    final previousStructures = <SessionStructure>[];
    for (var previousState in _previousStates) {
      previousStructures.add(previousState.structure);
    }
    final record = RecordStructure.create()
      ..currentSession = _sessionState.structure
      ..previousSessions.addAll(previousStructures);

    return record.toBuilder().writeToBuffer();
  }
}

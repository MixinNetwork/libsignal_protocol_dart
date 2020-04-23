import 'dart:collection';
import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/state/LocalStorageProtocol.pb.dart';

class SessionState extends LinkedListEntry<SessionState> {
  static final int MAX_MESSAGE_KEYS = 2000;

  SessionStructure _sessionStructure;

  SessionState() {
    this._sessionStructure = SessionStructure.create();
  }

  SessionState.fromStructure(SessionStructure sessionStructure) {
    this._sessionStructure = sessionStructure;
  }

  SessionState.fromSessionState(SessionState copy) {
    this._sessionStructure = copy._sessionStructure.toBuilder();
  }

  SessionStructure getStructure() {
    return _sessionStructure;
  }

  Uint8List getAliceBaseKey() {
    return this._sessionStructure.aliceBaseKey;
  }

  void setAliceBaseKey(Uint8List aliceBaseKey) {
    this._sessionStructure.aliceBaseKey = aliceBaseKey;
  }

  void setSessionVersion(int version) {
    this._sessionStructure.sessionVersion = version;
  }

  int getSessionVersion() {
    int sessionVersion = this._sessionStructure.sessionVersion;
    if (sessionVersion == 0)
      return 2;
    else
      return sessionVersion;
  }
}

import 'dart:collection';
import 'dart:io';

import 'package:libsignal_protocol_dart/src/groups/SenderKeyName.dart';
import 'package:libsignal_protocol_dart/src/groups/state/SenderKeyRecord.dart';
import 'package:libsignal_protocol_dart/src/groups/state/SenderKeyStore.dart';

class InMemorySenderKeyStore extends SenderKeyStore {
  final _store = HashMap<SenderKeyName, SenderKeyRecord>();

  @override
  Future<SenderKeyRecord> loadSenderKey(SenderKeyName senderKeyName) async {
    try {
      var record = _store[senderKeyName];
      if (record == null) {
        return SenderKeyRecord();
      } else {
        return SenderKeyRecord.fromSerialized(record.serialize());
      }
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future storeSenderKey(
      SenderKeyName senderKeyName, SenderKeyRecord record) async {
    _store[senderKeyName] = record;
  }
}

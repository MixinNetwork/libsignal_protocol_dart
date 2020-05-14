import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import '../../InvalidKeyIdException.dart';
import '../PreKeyRecord.dart';
import '../PreKeyStore.dart';

class InMemoryPreKeyStore extends PreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  bool containsPreKey(int preKeyId) {
    return store.containsKey(preKeyId);
  }

  @override
  PreKeyRecord loadPreKey(int preKeyId) {
    try {
      if (!store.containsKey(preKeyId)) {
        throw InvalidKeyIdException('No such prekeyrecord!');
      }

      return PreKeyRecord.fromBuffer(store[preKeyId]);
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  void removePreKey(int preKeyId) {
    store.remove(preKeyId);
  }

  @override
  void storePreKey(int preKeyId, PreKeyRecord record) {
    store[preKeyId] = record.serialize();
  }
}

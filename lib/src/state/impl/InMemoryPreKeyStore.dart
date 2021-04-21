import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import '../../InvalidKeyIdException.dart';
import '../PreKeyRecord.dart';
import '../PreKeyStore.dart';

class InMemoryPreKeyStore extends PreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    return store.containsKey(preKeyId);
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    try {
      if (!store.containsKey(preKeyId)) {
        throw InvalidKeyIdException('No such prekeyrecord! - $preKeyId');
      }

      return PreKeyRecord.fromBuffer(store[preKeyId]!);
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

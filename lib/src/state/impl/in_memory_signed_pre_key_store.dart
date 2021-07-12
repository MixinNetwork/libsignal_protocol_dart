import 'dart:collection';
import 'dart:typed_data';

import '../../invalid_key_id_exception.dart';
import '../signed_pre_key_record.dart';
import '../signed_pre_key_store.dart';

class InMemorySignedPreKeyStore extends SignedPreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    if (!store.containsKey(signedPreKeyId)) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord! $signedPreKeyId');
    }
    return SignedPreKeyRecord.fromSerialized(store[signedPreKeyId]!);
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final results = <SignedPreKeyRecord>[];
    for (var serialized in store.values) {
      results.add(SignedPreKeyRecord.fromSerialized(serialized));
    }
    return results;
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    store[signedPreKeyId] = record.serialize();
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      store.containsKey(signedPreKeyId);

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    store.remove(signedPreKeyId);
  }
}

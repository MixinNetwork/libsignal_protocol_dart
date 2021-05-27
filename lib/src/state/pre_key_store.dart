import 'pre_key_record.dart';

abstract class PreKeyStore {
  Future<PreKeyRecord> loadPreKey(
      int preKeyId); //  throws InvalidKeyIdException;

  void storePreKey(int preKeyId, PreKeyRecord record);

  Future<bool> containsPreKey(int preKeyId);

  void removePreKey(int preKeyId);
}

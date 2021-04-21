import 'PreKeyRecord.dart';

abstract class PreKeyStore {
  Future<PreKeyRecord> loadPreKey(
      int preKeyId); //  throws InvalidKeyIdException;

  void storePreKey(int preKeyId, PreKeyRecord record);

  Future<bool> containsPreKey(int preKeyId);

  void removePreKey(int preKeyId);
}

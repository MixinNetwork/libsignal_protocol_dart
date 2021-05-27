import 'signed_pre_key_record.dart';

abstract class SignedPreKeyStore {
  Future<SignedPreKeyRecord> loadSignedPreKey(
      int signedPreKeyId); //throws InvalidKeyIdException;

  Future<List<SignedPreKeyRecord>> loadSignedPreKeys();

  void storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record);

  Future<bool> containsSignedPreKey(int signedPreKeyId);

  void removeSignedPreKey(int signedPreKeyId);
}

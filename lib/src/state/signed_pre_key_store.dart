import 'signed_pre_key_record.dart';

abstract class SignedPreKeyStore {
  Future<SignedPreKeyRecord> loadSignedPreKey(
      int signedPreKeyId); //throws InvalidKeyIdException;

  Future<List<SignedPreKeyRecord>> loadSignedPreKeys();

  Future<void> storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record);

  Future<bool> containsSignedPreKey(int signedPreKeyId);

  Future<void> removeSignedPreKey(int signedPreKeyId);
}

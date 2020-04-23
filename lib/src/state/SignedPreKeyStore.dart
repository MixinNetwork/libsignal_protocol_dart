import 'package:libsignalprotocoldart/src/state/SignedPreKeyRecord.dart';

abstract class SignedPreKeyStore {
  SignedPreKeyRecord loadSignedPreKey(
      int signedPreKeyId); //throws InvalidKeyIdException;

  List<SignedPreKeyRecord> loadSignedPreKeys();

  void storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record);

  bool containsSignedPreKey(int signedPreKeyId);

  void removeSignedPreKey(int signedPreKeyId);
}

import 'package:libsignalprotocoldart/src/state/PreKeyRecord.dart';

abstract class PreKeyStore {
  PreKeyRecord loadPreKey(int preKeyId); //  throws InvalidKeyIdException;

  void storePreKey(int preKeyId, PreKeyRecord record);

  bool containsPreKey(int preKeyId);

  void removePreKey(int preKeyId);
}

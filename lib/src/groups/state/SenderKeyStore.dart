import '../SenderKeyName.dart';
import 'SenderKeyRecord.dart';

abstract class SenderKeyStore {
  void storeSenderKey(SenderKeyName senderKeyName, SenderKeyRecord record);

  SenderKeyRecord loadSenderKey(SenderKeyName senderKeyName);
}

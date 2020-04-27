import '../SenderKeyName.dart';
import 'SenderKeyRecord.dart';

abstract class SenderKeyStore {
  storeSenderKey(SenderKeyName senderKeyName, SenderKeyRecord record);

  SenderKeyRecord loadSenderKey(SenderKeyName senderKeyName);
}
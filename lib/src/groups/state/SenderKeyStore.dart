import '../SenderKeyName.dart';
import 'SenderKeyRecord.dart';

abstract class SenderKeyStore {
  Future storeSenderKey(SenderKeyName senderKeyName, SenderKeyRecord record);

  Future<SenderKeyRecord> loadSenderKey(SenderKeyName senderKeyName);
}

import '../sender_key_name.dart';
import 'sender_key_record.dart';

abstract class SenderKeyStore {
  Future storeSenderKey(SenderKeyName senderKeyName, SenderKeyRecord record);

  Future<SenderKeyRecord> loadSenderKey(SenderKeyName senderKeyName);
}

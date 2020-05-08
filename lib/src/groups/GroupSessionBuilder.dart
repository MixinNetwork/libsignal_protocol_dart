import '../state/WhisperTextProtocol.pb.dart';

import 'SenderKeyName.dart';
import 'state/SenderKeyStore.dart';

class GroupSessionBuilder {
  final SenderKeyStore _senderKeyStore;

  GroupSessionBuilder._(this._senderKeyStore);

  void process(SenderKeyName senderKeyName,
      SenderKeyDistributionMessage senderKeyDistributionMessage) {}

  SenderKeyDistributionMessage create(SenderKeyName senderKeyName) {}
}

import 'package:libsignalprotocoldart/src/state/WhisperTextProtocol.pb.dart';

import 'SenderKeyName.dart';
import 'state/SenderKeyStore.dart';

class GroupSessionBuilder {
  SenderKeyStore _senderKeyStore;

  GroupSessionBuilder._(this._senderKeyStore);

  process(SenderKeyName senderKeyName, SenderKeyDistributionMessage senderKeyDistributionMessage) {

  }

  SenderKeyDistributionMessage create(SenderKeyName senderKeyName) {

  }
}
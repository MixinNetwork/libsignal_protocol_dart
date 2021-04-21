import 'package:libsignal_protocol_dart/src/InvalidKeyException.dart';
import 'package:libsignal_protocol_dart/src/InvalidKeyIdException.dart';
import 'package:libsignal_protocol_dart/src/protocol/SenderKeyDistributionMessageWrapper.dart';
import 'package:libsignal_protocol_dart/src/util/KeyHelper.dart';

import 'SenderKeyName.dart';
import 'state/SenderKeyStore.dart';

class GroupSessionBuilder {
  final SenderKeyStore _senderKeyStore;

  GroupSessionBuilder(this._senderKeyStore);

  void process(
      SenderKeyName senderKeyName,
      SenderKeyDistributionMessageWrapper
          senderKeyDistributionMessageWrapper) async {
    var senderKeyRecord = await _senderKeyStore.loadSenderKey(senderKeyName);
    senderKeyRecord.addSenderKeyState(
        senderKeyDistributionMessageWrapper.id,
        senderKeyDistributionMessageWrapper.iteration,
        senderKeyDistributionMessageWrapper.chainKey,
        senderKeyDistributionMessageWrapper.signatureKey);
    await _senderKeyStore.storeSenderKey(senderKeyName, senderKeyRecord);
  }

  Future<SenderKeyDistributionMessageWrapper> create(
      SenderKeyName senderKeyName) async {
    try {
      var senderKeyRecord = await _senderKeyStore.loadSenderKey(senderKeyName);
      if (senderKeyRecord.isEmpty) {
        senderKeyRecord.setSenderKeyState(
            KeyHelper.generateSenderKeyId(),
            0,
            KeyHelper.generateSenderKey(),
            KeyHelper.generateSenderSigningKey());
        await _senderKeyStore.storeSenderKey(senderKeyName, senderKeyRecord);
      }
      var state = senderKeyRecord.getSenderKeyState();
      return SenderKeyDistributionMessageWrapper(
          state.keyId,
          state.senderChainKey.iteration,
          state.senderChainKey.seed,
          state.signingKeyPublic);
    } on InvalidKeyIdException catch (e) {
      throw AssertionError(e);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }
}

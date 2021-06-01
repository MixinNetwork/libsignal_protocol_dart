import '../invalid_key_exception.dart';
import '../invalid_key_id_exception.dart';
import '../protocol/sender_key_distribution_message_wrapper.dart';
import '../util/key_helper.dart';
import 'sender_key_name.dart';
import 'state/sender_key_store.dart';

class GroupSessionBuilder {
  GroupSessionBuilder(this._senderKeyStore);

  final SenderKeyStore _senderKeyStore;

  Future<void> process(
      SenderKeyName senderKeyName,
      SenderKeyDistributionMessageWrapper
          senderKeyDistributionMessageWrapper) async {
    final senderKeyRecord = await _senderKeyStore.loadSenderKey(senderKeyName);
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
      final senderKeyRecord =
          await _senderKeyStore.loadSenderKey(senderKeyName);
      if (senderKeyRecord.isEmpty) {
        senderKeyRecord.setSenderKeyState(generateSenderKeyId(), 0,
            generateSenderKey(), generateSenderSigningKey());
        await _senderKeyStore.storeSenderKey(senderKeyName, senderKeyRecord);
      }
      final state = senderKeyRecord.getSenderKeyState();
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

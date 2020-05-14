import 'package:libsignal_protocol_dart/src/InvalidKeyException.dart';
import 'package:libsignal_protocol_dart/src/SessionBuilder.dart';
import 'package:libsignal_protocol_dart/src/SignalProtocolAddress.dart';
import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/state/PreKeyBundle.dart';
import 'package:test/test.dart';

import 'test_in_memory_signal_protocol_store.dart';

void main() {
  final ALICE_ADDRESS = SignalProtocolAddress('+14151111111', 1);
  final BOB_ADDRESS = SignalProtocolAddress('+14152222222', 1);

  test('testBasicPreKeyV2', () {
    final aliceStore = TestInMemorySignalProtocolStore();
    final aliceSessionBuilder =
        SessionBuilder.fromSignalStore(aliceStore, BOB_ADDRESS);

    var bobStore = TestInMemorySignalProtocolStore();
    var bobPreKeyPair = Curve.generateKeyPair();
    var bobPreKey = PreKeyBundle(
        bobStore.getLocalRegistrationId(),
        1,
        31337,
        bobPreKeyPair.publicKey,
        0,
        null,
        null,
        bobStore.getIdentityKeyPair().getPublicKey());
    try {
      aliceSessionBuilder.processPreKeyBundle(bobPreKey);
      throw AssertionError('Should fail with missing unsigned prekey!');
    } on InvalidKeyException catch (e) {
      // Good!
      return;
    }
  });
}

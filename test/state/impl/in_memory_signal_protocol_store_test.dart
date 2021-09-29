import 'dart:convert';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

import '../../test_in_memory_signal_protocol_store.dart';

void main() {
  test('should encrypt/decrypt message from Alice, to Bob and back again',
      () async {
    final aliceStore = TestInMemorySignalProtocolStore();
    final bobStore = TestInMemorySignalProtocolStore();
    const msgOrig = "L'homme est condamné à être libre";

    const aliceAddress = SignalProtocolAddress('alice', 1);
    const bobAddress = SignalProtocolAddress('bob', 1);

    // Bob creates his keys to store locally and to publish public to cloud
    final bobPreKeyPair = Curve.generateKeyPair();
    final bobSignedPreKeyPair = Curve.generateKeyPair();
    final bobSignedPreKeySignature = Curve.calculateSignature(
      await bobStore
          .getIdentityKeyPair()
          .then((value) => value.getPrivateKey()),
      bobSignedPreKeyPair.publicKey.serialize(),
    );

    //
    // Alice to encrypt and send to Bob...
    //

    // Pretend that Alice has downloaded Bob's pre key bundle from the cloud
    final bobPreKey = PreKeyBundle(
      await bobStore.getLocalRegistrationId(),
      1,
      31337,
      bobPreKeyPair.publicKey,
      22,
      bobSignedPreKeyPair.publicKey,
      bobSignedPreKeySignature,
      await bobStore.getIdentityKeyPair().then((value) => value.getPublicKey()),
    );

    await SessionBuilder.fromSignalStore(aliceStore, bobAddress)
        .processPreKeyBundle(bobPreKey);

    final aliceSessionCipher = SessionCipher.fromStore(aliceStore, bobAddress);
    final msgAliceToBob = await aliceSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(msgOrig)));

    // Pretend that Alice has now sent the message to Bob

    //
    // Bob to decrypt...
    //

    await bobStore.storePreKey(
      31337,
      PreKeyRecord(bobPreKey.getPreKeyId(), bobPreKeyPair),
    );
    await bobStore.storeSignedPreKey(
      22,
      SignedPreKeyRecord(
        22,
        Int64(DateTime.now().millisecondsSinceEpoch),
        bobSignedPreKeyPair,
        bobSignedPreKeySignature,
      ),
    );

    final msgIn = PreKeySignalMessage(msgAliceToBob.serialize());
    expect(
      msgIn.getType(),
      CiphertextMessage.prekeyType,
    );

    final bobSessionCipher = SessionCipher.fromStore(bobStore, aliceAddress);
    var msgDecrypted = await bobSessionCipher.decrypt(msgIn);
    var msgDecoded = utf8.decode(msgDecrypted, allowMalformed: true);
    expect(msgDecoded, msgOrig);

    //
    // Bob to encrypt and send to Alice...
    //

    final msgBobToAlice = await bobSessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(msgDecoded)));
    expect(
      msgBobToAlice.getType(),
      CiphertextMessage.whisperType,
    );

    //
    // Alice to decrypt...
    //

    msgDecrypted = await aliceSessionCipher.decryptFromSignal(
      SignalMessage.fromSerialized(msgBobToAlice.serialize()),
    );
    msgDecoded = utf8.decode(msgDecrypted, allowMalformed: true);
    expect(msgDecoded, msgOrig);
  });
}

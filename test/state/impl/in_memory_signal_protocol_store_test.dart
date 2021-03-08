import 'dart:convert';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:test/test.dart';

import '../../test_in_memory_signal_protocol_store.dart';

void main() {
  test('should encrypt/decrypt message from Alice, to Bob and back again', () {
    final aliceStore = TestInMemorySignalProtocolStore();
    final bobStore = TestInMemorySignalProtocolStore();
    final msgOrig = "L'homme est condamné à être libre";

    final aliceAddress = SignalProtocolAddress('alice', 1);
    final bobAddress = SignalProtocolAddress('bob', 1);

    // Bob creates his keys to store locally and to publish public to cloud
    final bobPreKeyPair = Curve.generateKeyPair();
    final bobSignedPreKeyPair = Curve.generateKeyPair();
    final bobSignedPreKeySignature = Curve.calculateSignature(
      bobStore.getIdentityKeyPair().getPrivateKey(),
      bobSignedPreKeyPair.publicKey.serialize(),
    );

    //
    // Alice to encrypt and send to Bob...
    //

    // Pretend that Alice has downloaded Bob's pre key bundle from the cloud
    final bobPreKey = PreKeyBundle(
      bobStore.getLocalRegistrationId(),
      1,
      31337,
      bobPreKeyPair.publicKey,
      22,
      bobSignedPreKeyPair.publicKey,
      bobSignedPreKeySignature,
      bobStore.getIdentityKeyPair().getPublicKey(),
    );

    SessionBuilder.fromSignalStore(aliceStore, bobAddress)
        .processPreKeyBundle(bobPreKey);

    var aliceSessionCipher = SessionCipher.fromStore(aliceStore, bobAddress);
    var msgAliceToBob =
        aliceSessionCipher.encrypt(Uint8List.fromList(utf8.encode(msgOrig)));

    // Pretend that Alice has now sent the message to Bob

    //
    // Bob to decrypt...
    //

    bobStore.storePreKey(
      31337,
      PreKeyRecord(bobPreKey.getPreKeyId(), bobPreKeyPair),
    );
    bobStore.storeSignedPreKey(
      22,
      SignedPreKeyRecord(
        22,
        Int64(DateTime.now().millisecondsSinceEpoch),
        bobSignedPreKeyPair,
        bobSignedPreKeySignature,
      ),
    );

    var msgIn = PreKeySignalMessage(msgAliceToBob.serialize());
    expect(
      msgIn.getType(),
      CiphertextMessage.PREKEY_TYPE,
    );

    var bobSessionCipher = SessionCipher.fromStore(bobStore, aliceAddress);
    var msgDecrypted = bobSessionCipher.decrypt(msgIn);
    var msgDecoded = utf8.decode(msgDecrypted, allowMalformed: true);
    expect(msgDecoded, msgOrig);

    //
    // Bob to encrypt and send to Alice...
    //

    var msgBobToAlice =
        bobSessionCipher.encrypt(Uint8List.fromList(utf8.encode(msgDecoded)));
    expect(
      msgBobToAlice.getType(),
      CiphertextMessage.WHISPER_TYPE,
    );

    //
    // Alice to decrypt...
    //

    msgDecrypted = aliceSessionCipher.decryptFromSignal(
      SignalMessage.fromSerialized(msgBobToAlice.serialize()),
    );
    msgDecoded = utf8.decode(msgDecrypted, allowMalformed: true);
    expect(msgDecoded, msgOrig);
  });
}

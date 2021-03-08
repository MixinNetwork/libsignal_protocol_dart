import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/ecc/Curve.dart';
import 'package:libsignal_protocol_dart/src/state/WhisperTextProtocol.pb.dart';
import 'package:protobuf/protobuf.dart';

import '../IdentityKey.dart';
import '../IdentityKeyPair.dart';
import '../InvalidKeyException.dart';
import '../InvalidMessageException.dart';
import '../devices/DeviceConsistencyCommitment.dart';
import '../devices/DeviceConsistencySignature.dart';

class DeviceConsistencyMessage {
  late DeviceConsistencySignature _signature;
  late int _generation;
  late Uint8List _serialized;

  DeviceConsistencyMessage(
      DeviceConsistencyCommitment commitment, IdentityKeyPair identityKeyPair) {
    try {
      var signatureBytes = Curve.calculateVrfSignature(
          identityKeyPair.getPrivateKey(), commitment.serialized);
      var vrfOutputBytes = Curve.verifyVrfSignature(
          identityKeyPair.getPublicKey().publicKey,
          commitment.serialized,
          signatureBytes);

      _generation = commitment.generation;
      _signature = DeviceConsistencySignature(signatureBytes, vrfOutputBytes);
      var d = DeviceConsistencyCodeMessage.create()
        ..generation = commitment.generation
        ..signature = _signature.signature.toList();
      _serialized = d.writeToBuffer();
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
//    } on VrfSignatureVerificationFailedException catch (e) {
//    throw AssertionError(e);
//    }
  }

  DeviceConsistencyMessage.fromSerialized(
      DeviceConsistencyCommitment commitment,
      Uint8List serialized,
      IdentityKey identityKey) {
    try {
      var message = DeviceConsistencyCodeMessage.fromBuffer(serialized);
      var vrfOutputBytes = Curve.verifyVrfSignature(identityKey.publicKey,
          commitment.serialized, Uint8List.fromList(message.signature));

      _generation = message.generation;
      _signature = DeviceConsistencySignature(
          Uint8List.fromList(message.signature), vrfOutputBytes);
      _serialized = serialized;
    } on InvalidProtocolBufferException catch (e) {
      throw InvalidMessageException(e.message);
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
//    } on VrfSignatureVerificationFailedException catch (e) {
//    throw AssertionError(e);
//    }
  }

  Uint8List get serialized => _serialized;

  DeviceConsistencySignature get signature => _signature;

  int get generation => _generation;
}

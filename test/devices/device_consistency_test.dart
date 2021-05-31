import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/devices/device_consistency_code_generator.dart';
import 'package:libsignal_protocol_dart/src/devices/device_consistency_commitment.dart';
import 'package:libsignal_protocol_dart/src/devices/device_consistency_signature.dart';
import 'package:libsignal_protocol_dart/src/protocol/device_consistency_message.dart';
import 'package:libsignal_protocol_dart/src/util/key_helper.dart';
import 'package:test/test.dart';

void main() {
  String _generateCode(DeviceConsistencyCommitment commitment,
      List<DeviceConsistencyMessage> messages) {
    final signatures = <DeviceConsistencySignature>[];
    for (var message in messages) {
      signatures.add(message.signature);
    }
    return DeviceConsistencyCodeGenerator.generateFor(commitment, signatures);
  }

  test('testDeviceConsistency', () {
    final deviceOne = generateIdentityKeyPair();
    final deviceTwo = generateIdentityKeyPair();
    final deviceThree = generateIdentityKeyPair();

    final keyList = <IdentityKey>[
      deviceOne.getPublicKey(),
      deviceTwo.getPublicKey(),
      deviceThree.getPublicKey()
    ]..shuffle();
    final deviceOneCommitment = DeviceConsistencyCommitment(1, keyList);

    keyList.shuffle();
    final deviceTwoCommitment = DeviceConsistencyCommitment(1, keyList);

    keyList.shuffle();
    final deviceThreeCommitment = DeviceConsistencyCommitment(1, keyList);

    expect(deviceOneCommitment.serialized, deviceTwoCommitment.serialized);
    expect(deviceTwoCommitment.serialized, deviceThreeCommitment.serialized);

    final deviceOneMessage =
        DeviceConsistencyMessage(deviceOneCommitment, deviceOne);
    final deviceTwoMessage =
        DeviceConsistencyMessage(deviceOneCommitment, deviceTwo);
    final deviceThreeMessage =
        DeviceConsistencyMessage(deviceOneCommitment, deviceThree);

    final receivedDeviceOneMessage = DeviceConsistencyMessage.fromSerialized(
        deviceOneCommitment,
        deviceOneMessage.serialized,
        deviceOne.getPublicKey());
    final receivedDeviceTwoMessage = DeviceConsistencyMessage.fromSerialized(
        deviceOneCommitment,
        deviceTwoMessage.serialized,
        deviceTwo.getPublicKey());
    final receivedDeviceThreeMessage = DeviceConsistencyMessage.fromSerialized(
        deviceOneCommitment,
        deviceThreeMessage.serialized,
        deviceThree.getPublicKey());

    expect(deviceOneMessage.signature.vrfOutput,
        receivedDeviceOneMessage.signature.vrfOutput);
    expect(deviceTwoMessage.signature.vrfOutput,
        receivedDeviceTwoMessage.signature.vrfOutput);
    expect(deviceThreeMessage.signature.vrfOutput,
        receivedDeviceThreeMessage.signature.vrfOutput);

    final codeOne = _generateCode(deviceOneCommitment, [
      deviceOneMessage,
      receivedDeviceTwoMessage,
      receivedDeviceThreeMessage
    ]);
    final codeTwo = _generateCode(deviceTwoCommitment, [
      deviceTwoMessage,
      receivedDeviceThreeMessage,
      receivedDeviceOneMessage
    ]);
    final codeThree = _generateCode(deviceThreeCommitment, [
      deviceThreeMessage,
      receivedDeviceTwoMessage,
      receivedDeviceOneMessage
    ]);

    expect(codeOne, codeTwo);
    expect(codeTwo, codeThree);
  }, skip: 'Failing historical test');
}

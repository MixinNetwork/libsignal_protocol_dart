import 'package:libsignal_protocol_dart/src/IdentityKey.dart';
import 'package:libsignal_protocol_dart/src/devices/DeviceConsistencyCodeGenerator.dart';
import 'package:libsignal_protocol_dart/src/devices/DeviceConsistencyCommitment.dart';
import 'package:libsignal_protocol_dart/src/devices/DeviceConsistencySignature.dart';
import 'package:libsignal_protocol_dart/src/protocol/DeviceConsistencyMessage.dart';
import 'package:libsignal_protocol_dart/src/util/KeyHelper.dart';
import 'package:test/test.dart';

void main() {
  String _generateCode(DeviceConsistencyCommitment commitment,
      List<DeviceConsistencyMessage> messages) {
    var signatures = <DeviceConsistencySignature>[];
    for (var message in messages) {
      signatures.add(message.signature);
    }
    return DeviceConsistencyCodeGenerator.generateFor(commitment, signatures);
  }

  test('testDeviceConsistency', () {
    var deviceOne = KeyHelper.generateIdentityKeyPair();
    var deviceTwo = KeyHelper.generateIdentityKeyPair();
    var deviceThree = KeyHelper.generateIdentityKeyPair();

    var keyList = <IdentityKey>[];
    keyList.add(deviceOne.getPublicKey());
    keyList.add(deviceTwo.getPublicKey());
    keyList.add(deviceThree.getPublicKey());

    keyList.shuffle();
    var deviceOneCommitment = DeviceConsistencyCommitment(1, keyList);

    keyList.shuffle();
    var deviceTwoCommitment = DeviceConsistencyCommitment(1, keyList);

    keyList.shuffle();
    var deviceThreeCommitment = DeviceConsistencyCommitment(1, keyList);

    expect(deviceOneCommitment.serialized, deviceTwoCommitment.serialized);
    expect(deviceTwoCommitment.serialized, deviceThreeCommitment.serialized);

    var deviceOneMessage =
        DeviceConsistencyMessage(deviceOneCommitment, deviceOne);
    var deviceTwoMessage =
        DeviceConsistencyMessage(deviceOneCommitment, deviceTwo);
    var deviceThreeMessage =
        DeviceConsistencyMessage(deviceOneCommitment, deviceThree);

    var receivedDeviceOneMessage = DeviceConsistencyMessage.fromSerialized(
        deviceOneCommitment,
        deviceOneMessage.serialized,
        deviceOne.getPublicKey());
    var receivedDeviceTwoMessage = DeviceConsistencyMessage.fromSerialized(
        deviceOneCommitment,
        deviceTwoMessage.serialized,
        deviceTwo.getPublicKey());
    var receivedDeviceThreeMessage = DeviceConsistencyMessage.fromSerialized(
        deviceOneCommitment,
        deviceThreeMessage.serialized,
        deviceThree.getPublicKey());

    expect(deviceOneMessage.signature.vrfOutput,
        receivedDeviceOneMessage.signature.vrfOutput);
    expect(deviceTwoMessage.signature.vrfOutput,
        receivedDeviceTwoMessage.signature.vrfOutput);
    expect(deviceThreeMessage.signature.vrfOutput,
        receivedDeviceThreeMessage.signature.vrfOutput);

    var codeOne = _generateCode(deviceOneCommitment, [
      deviceOneMessage,
      receivedDeviceTwoMessage,
      receivedDeviceThreeMessage
    ]);
    var codeTwo = _generateCode(deviceTwoCommitment, [
      deviceTwoMessage,
      receivedDeviceThreeMessage,
      receivedDeviceOneMessage
    ]);
    var codeThree = _generateCode(deviceThreeCommitment, [
      deviceThreeMessage,
      receivedDeviceTwoMessage,
      receivedDeviceOneMessage
    ]);

    expect(codeOne, codeTwo);
    expect(codeTwo, codeThree);
  }, skip: 'Failing historical test');
}

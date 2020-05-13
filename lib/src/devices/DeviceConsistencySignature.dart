import 'dart:typed_data';

class DeviceConsistencySignature {
  final Uint8List _signature;
  final Uint8List _vrfOutput;

  DeviceConsistencySignature(this._signature, this._vrfOutput);

  Uint8List get vrfOutput => _vrfOutput;

  Uint8List get signature => _signature;
}

import 'package:meta/meta.dart';

@immutable
class SignalProtocolAddress {
  const SignalProtocolAddress(this._name, this._deviceId);

  final String _name;
  final int _deviceId;

  String getName() => _name;

  int getDeviceId() => _deviceId;

  @override
  String toString() => '$_name:$_deviceId';

  @override
  bool operator ==(Object other) {
    if (other is! SignalProtocolAddress) return false;

    return _name == other._name && _deviceId == other._deviceId;
  }

  @override
  int get hashCode => _name.hashCode ^ _deviceId;
}

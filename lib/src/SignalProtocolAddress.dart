class SignalProtocolAddress {
  final String _name;
  final int _deviceId;

  SignalProtocolAddress(this._name, this._deviceId);

  String getName() {
    return _name;
  }

  int getDeviceId() {
    return _deviceId;
  }

  @override
  String toString() {
    return '$_name:$_deviceId';
  }

  @override
  bool operator ==(other) {
    if (!(other is SignalProtocolAddress)) return false;

    return _name == other._name && _deviceId == other._deviceId;
  }

  @override
  int get hashCode => _name.hashCode ^ _deviceId;
}

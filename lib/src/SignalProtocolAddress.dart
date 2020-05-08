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

    var that = other as SignalProtocolAddress;
    return _name == that._name && _deviceId == that._deviceId;
  }

  @override
  int get hashCode => _name.hashCode ^ _deviceId;
}

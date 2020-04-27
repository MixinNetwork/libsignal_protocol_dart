class SignalProtocolAddress {
  String _name;
  int _deviceId;

  SignalProtocolAddress(this._name, this._deviceId);

  String getName() {
    return _name;
  }

  int getDeviceId() {
    return _deviceId;
  }

  @override
  String toString() {
    return "$_name:$_deviceId";
  }

  @override
  bool operator ==(other) {
    if (other == null) return false;
    if (!(other is SignalProtocolAddress)) return false;

    SignalProtocolAddress that = other as SignalProtocolAddress;
    return this._name == that._name && this._deviceId == that._deviceId;
  }

  @override
  int get hashCode => this._name.hashCode ^ this._deviceId;
}

class SignalProtocolAddress {
  String _name;
  int _deviceId;

  SignalProtocolAddress(String name, int deviceId) {
    this._name = name;
    this._deviceId = deviceId;
  }

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

  //   @Override
  // public boolean equals(Object other) {
  //   if (other == null)                       return false;
  //   if (!(other instanceof SignalProtocolAddress)) return false;

  //   SignalProtocolAddress that = (SignalProtocolAddress)other;
  //   return this.name.equals(that.name) && this.deviceId == that.deviceId;
  // }

  // @Override
  // public int hashCode() {
  //   return this.name.hashCode() ^ this.deviceId;
  // }

}

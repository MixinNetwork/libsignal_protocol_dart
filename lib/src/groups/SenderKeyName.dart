import '../SignalProtocolAddress.dart';

class SenderKeyName {
  final String _groupId;
  final SignalProtocolAddress _sender;

  SenderKeyName(this._groupId, this._sender);

  String get groupId => _groupId;

  SignalProtocolAddress get sender => _sender;

  String serialize() {
    return '$_groupId::${_sender.getName()}::${_sender.getDeviceId()}';
  }

  @override
  bool operator ==(other) {
    if (!(other is SenderKeyName)) return false;

    var that = other as SenderKeyName;
    return _groupId == that.groupId && _sender == that.sender;
  }

  @override
  int get hashCode => _groupId.hashCode ^ _sender.hashCode;
}

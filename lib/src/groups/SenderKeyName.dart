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

    return _groupId == other.groupId && _sender == other.sender;
  }

  @override
  int get hashCode => _groupId.hashCode ^ _sender.hashCode;
}

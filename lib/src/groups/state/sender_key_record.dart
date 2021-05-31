import 'dart:collection';
import 'dart:typed_data';

import '../../ecc/ec_key_pair.dart';
import '../../ecc/ec_public_key.dart';
import '../../entry.dart';
import '../../invalid_key_id_exception.dart';
import '../../state/local_storage_protocol.pb.dart';
import 'sender_key_state.dart';

class SenderKeyRecord {
  SenderKeyRecord();

  SenderKeyRecord.fromSerialized(Uint8List serialized) {
    final senderKeyRecordStructure =
        SenderKeyRecordStructure.fromBuffer(serialized);
    for (var structure in senderKeyRecordStructure.senderKeyStates) {
      _senderKeyStates
          .add(Entry(SenderKeyState.fromSenderKeyStateStructure(structure)));
    }
  }

  static const int _maxStates = 5;

  final LinkedList<Entry<SenderKeyState>> _senderKeyStates =
      LinkedList<Entry<SenderKeyState>>();

  bool get isEmpty => _senderKeyStates.isEmpty;

  SenderKeyState getSenderKeyState() {
    if (_senderKeyStates.isNotEmpty) {
      return _senderKeyStates.first.value;
    } else {
      throw InvalidKeyIdException('No key state in record!');
    }
  }

  SenderKeyState getSenderKeyStateById(int keyId) {
    for (var state in _senderKeyStates) {
      if (state.value.keyId == keyId) {
        return state.value;
      }
    }
    throw InvalidKeyIdException('No key for: $keyId');
  }

  void addSenderKeyState(
      int id, int iteration, Uint8List chainKey, ECPublicKey signatureKey) {
    _senderKeyStates.addFirst(Entry(
        SenderKeyState.fromPublicKey(id, iteration, chainKey, signatureKey)));
    if (_senderKeyStates.length > _maxStates) {
      _senderKeyStates.remove(_senderKeyStates.last);
    }
  }

  void setSenderKeyState(
      int id, int iteration, Uint8List chainKey, ECKeyPair signatureKey) {
    _senderKeyStates
      ..clear()
      ..add(Entry(
          SenderKeyState.fromKeyPair(id, iteration, chainKey, signatureKey)));
  }

  Uint8List serialize() {
    final recordStructure = SenderKeyRecordStructure.create();
    _senderKeyStates.forEach((entry) {
      recordStructure.senderKeyStates.add(entry.value.structure);
    });
    return recordStructure.writeToBuffer();
  }
}

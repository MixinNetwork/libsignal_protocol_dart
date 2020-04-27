import 'dart:collection';
import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/groups/state/SenderKeyState.dart';
import 'package:libsignalprotocoldart/src/state/LocalStorageProtocol.pb.dart';

import '../../InvalidKeyIdException.dart';

class SenderKeyRecord {
  static const int _MAX_STATES = 5;

  LinkedList<Entry<SenderKeyState>> _senderKeyStates = LinkedList<Entry<SenderKeyState>>();

  SenderKeyRecord._();

  SenderKeyRecord.fromSerialized(Uint8List serialized) {
    SenderKeyRecordStructure senderKeyRecordStructure = SenderKeyRecordStructure.fromBuffer(serialized);
    for (var structure in senderKeyRecordStructure.senderKeyStates) {
      _senderKeyStates.add(Entry(SenderKeyState.fromSenderKeyStateStructure(structure)));
    }
  }

  bool get isEmpty => _senderKeyStates.isEmpty;

  SenderKeyState getSenderKeyState() {
    if(_senderKeyStates.isNotEmpty) {
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

  addSenderKeyState(int id, int iteration, Uint8List chainKey, ECPublicKey signatureKey) {
    _senderKeyStates.addFirst(Entry(SenderKeyState.fromPublicKey(id, iteration, chainKey, signatureKey)));
    if (_senderKeyStates.length > _MAX_STATES) {
      _senderKeyStates.remove(_senderKeyStates.last);
    }
  }

  setSenderKeyState(int id, int iteration, Uint8List chainKey, ECKeyPair signatureKey) {
    _senderKeyStates.clear();
    _senderKeyStates.add(Entry(SenderKeyState.fromKeyPair(id, iteration, chainKey, signatureKey)));
  }

//  Uint8List serialize() {
//    var recordStructure = SenderKeyRecordStructure.getDefault();
//    for (var senderKeyState in _senderKeyStates) {
//      recordStructure.senderKeyStates.add(senderKeyState.value.structure);
//    }
//    return recordStructure
//  }
}

class Entry<T> extends LinkedListEntry<Entry<T>> {
  T value;
  Entry(this.value);
}
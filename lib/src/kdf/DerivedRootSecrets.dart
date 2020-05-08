import 'dart:typed_data';

import '../util/ByteUtil.dart';

class DerivedRootSecrets {
  static final int SIZE = 64;

  Uint8List _rootKey;
  Uint8List _chainKey;

  DerivedRootSecrets(Uint8List okm) {
    List<Uint8List> keys = ByteUtil.splitTwo(okm, 32, 32);
    this._rootKey = keys[0];
    this._chainKey = keys[1];
  }

  Uint8List getRootKey() {
    return _rootKey;
  }

  Uint8List getChainKey() {
    return _chainKey;
  }
}

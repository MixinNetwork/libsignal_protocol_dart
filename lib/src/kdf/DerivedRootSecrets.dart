import 'dart:typed_data';

import '../util/ByteUtil.dart';

class DerivedRootSecrets {
  static final int SIZE = 64;

  late Uint8List _rootKey;
  late Uint8List _chainKey;

  DerivedRootSecrets(Uint8List okm) {
    var keys = ByteUtil.splitTwo(okm, 32, 32);
    _rootKey = keys[0];
    _chainKey = keys[1];
  }

  Uint8List getRootKey() {
    return _rootKey;
  }

  Uint8List getChainKey() {
    return _chainKey;
  }
}

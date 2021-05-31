import 'dart:typed_data';

import '../util/byte_util.dart';

class DerivedRootSecrets {
  DerivedRootSecrets(Uint8List okm) {
    final keys = ByteUtil.splitTwo(okm, 32, 32);
    _rootKey = keys[0];
    _chainKey = keys[1];
  }

  static const int size = 64;

  late Uint8List _rootKey;
  late Uint8List _chainKey;

  Uint8List getRootKey() => _rootKey;

  Uint8List getChainKey() => _chainKey;
}

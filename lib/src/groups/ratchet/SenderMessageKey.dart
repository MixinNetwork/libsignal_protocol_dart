import 'dart:typed_data';

import '../../kdf/HKDFv3.dart';
import '../../util/ByteUtil.dart';

class SenderMessageKey {
  int _iteration;
  Uint8List _iv;
  Uint8List _cipherKey;
  Uint8List _seed;

  SenderMessageKey(int iteration, Uint8List seed) {
    var derivative = HKDFv3()
        .deriveSecrets(seed, Uint8List.fromList('WhisperGroup'.codeUnits), 48);
    var parts = ByteUtil.splitTwo(derivative, 16, 32);

    _iteration = iteration;
    _seed = seed;
    _iv = parts[0];
    _cipherKey = parts[1];
  }

  int get iteration => _iteration;
  Uint8List get iv => _iv;
  Uint8List get cipherKey => _cipherKey;
  Uint8List get seed => _seed;
}

import 'dart:typed_data';

import '../../kdf/hkdfv3.dart';
import '../../util/byte_util.dart';

class SenderMessageKey {
  SenderMessageKey(this._iteration, this._seed) {
    final derivative = HKDFv3()
        .deriveSecrets(seed, Uint8List.fromList('WhisperGroup'.codeUnits), 48);
    final parts = ByteUtil.splitTwo(derivative, 16, 32);
    _iv = parts[0];
    _cipherKey = parts[1];
  }

  final int _iteration;
  final Uint8List _seed;
  late Uint8List _iv;
  late Uint8List _cipherKey;

  int get iteration => _iteration;
  Uint8List get iv => _iv;
  Uint8List get cipherKey => _cipherKey;
  Uint8List get seed => _seed;
}

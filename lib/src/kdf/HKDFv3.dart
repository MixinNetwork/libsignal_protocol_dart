import 'package:libsignalprotocoldart/src/kdf/HKDF.dart';

class HKDFv3 extends HKDF {
  @override
  int getIterationStartOffset() {
    return 1;
  }
}

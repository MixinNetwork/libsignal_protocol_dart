import 'HKDF.dart';

class HKDFv2 extends HKDF {
  @override
  int getIterationStartOffset() {
    return 0;
  }
}

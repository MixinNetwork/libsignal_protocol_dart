import 'hkdf.dart';

class HKDFv3 extends HKDF {
  @override
  int getIterationStartOffset() {
    return 1;
  }
}

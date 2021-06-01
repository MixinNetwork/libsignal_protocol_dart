import 'hkdf.dart';

class HKDFv3 extends HKDF {
  @override
  int getIterationStartOffset() => 1;
}

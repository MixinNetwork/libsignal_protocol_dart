import 'hkdf.dart';

class HKDFv2 extends HKDF {
  @override
  int getIterationStartOffset() => 0;
}

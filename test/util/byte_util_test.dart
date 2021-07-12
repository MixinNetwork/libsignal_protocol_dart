import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/util/byte_util.dart';
import 'package:test/test.dart';

void main() {
  test('ByteUtil.combime() combile multi Uintlist8 into 1', () {
    final first = Uint8List.fromList([1]);
    final second = Uint8List.fromList([2, 3]);
    final third = Uint8List.fromList([4, 5]);
    final other = Uint8List.fromList([1, 2, 3, 4, 5]);
    expect(ByteUtil.combine([first, second, third]), other);
  });

  test('ByteUtil.shortToByteArray() convert short to UintList8', () {
    const value1 = 100;
    expect(ByteUtil.shortToByteArray(value1), Uint8List.fromList([0, 100]));
    const value2 = 1024;
    expect(ByteUtil.shortToByteArray(value2), Uint8List.fromList([4, 1024]));
  });

  test('ByteUtil.intToByteArray() convert int to UintList8', () {
    const value1 = 100;
    expect(ByteUtil.intToByteArray(value1), Uint8List.fromList([0, 0, 0, 100]));
    const value2 = 1024;
    expect(ByteUtil.intToByteArray(value2), Uint8List.fromList([0, 0, 4, 0]));
  });

  test('ByteUtil.trim() sublist Uint8List from 0 to specification length', () {
    final input = Uint8List.fromList([1, 2, 3, 4, 5]);
    expect(ByteUtil.trim(input, 3), Uint8List.fromList([1, 2, 3]));
    expect(ByteUtil.trim(input, 0), Uint8List.fromList([]));
  });

  test('ByteUtil.split() splits the string to three length', () {
    final input = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final first = Uint8List.fromList([1]);
    final second = Uint8List.fromList([2, 3]);
    final third = Uint8List.fromList([4, 5, 6, 7, 8, 9]);
    expect(ByteUtil.split(input, 1, 2, 6), [first, second, third]);
  });

  test('ByteUtil.splitTwo() splits the string to two length', () {
    final input = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    final first = Uint8List.fromList([1]);
    final second = Uint8List.fromList([2, 3, 4, 5, 6, 7]);
    expect(ByteUtil.splitTwo(input, 1, 6), [first, second]);
  });

  test('String.trim() removes surrounding whitespace', () {
    const string = '  foo ';
    expect(string.trim(), equals('foo'));
  });

  test('ByteUtil.intsToByteHighAndLow()', () {
    const highValue1 = 4;
    const lowValue1 = 2;
    expect(ByteUtil.intsToByteHighAndLow(highValue1, lowValue1), 66);
    const highValue2 = 2;
    const lowValue2 = 4;
    expect(ByteUtil.intsToByteHighAndLow(highValue2, lowValue2), 36);
    const highValue3 = 3;
    const lowValue3 = 3;
    expect(ByteUtil.intsToByteHighAndLow(highValue3, lowValue3), 51);
  });

  test('ByteUtil.highBitsToInt', () {
    const int1 = 16;
    expect(ByteUtil.highBitsToInt(int1), 1);
    const int2 = 35;
    expect(ByteUtil.highBitsToInt(int2), 2);
    const int3 = 100;
    expect(ByteUtil.highBitsToInt(int3), 6);
  });

  test('ByteUtil.lowBitsToInt', () {
    const int1 = 16;
    expect(ByteUtil.lowBitsToInt(int1), 0);
    const int2 = 35;
    expect(ByteUtil.lowBitsToInt(int2), 3);
    const int3 = 100;
    expect(ByteUtil.lowBitsToInt(int3), 4);
  });

  test('ByteUtil.highBitsToMedium', () {
    const int1 = 16;
    expect(ByteUtil.highBitsToMedium(int1), 0);
    const int2 = 35;
    expect(ByteUtil.highBitsToMedium(int2), 0);
    const int3 = 100;
    expect(ByteUtil.highBitsToMedium(int3), 0);
    const int4 = 10000;
    expect(ByteUtil.highBitsToMedium(int4), 2);
  });

  test('ByteUtil.lowBitsToMedium', () {
    const int1 = 16;
    expect(ByteUtil.lowBitsToMedium(int1), 16);
    const int2 = 35;
    expect(ByteUtil.lowBitsToMedium(int2), 35);
    const int3 = 100;
    expect(ByteUtil.lowBitsToMedium(int3), 100);
    const int4 = 10000;
    expect(ByteUtil.lowBitsToMedium(int4), 1808);
  });

  test('ByteUtil.byteArray5ToLong', () {
    // ignore: unused_local_variable
    final input = Uint8List.fromList(
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    // TODO
  });
}

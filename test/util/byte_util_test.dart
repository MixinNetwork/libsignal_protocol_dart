import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/util/byte_util.dart';
import 'package:test/test.dart';

void main() {
  test('ByteUtil.combime() combile multi Uintlist8 into 1', () {
    var first = Uint8List.fromList([1]);
    var second = Uint8List.fromList([2, 3]);
    var third = Uint8List.fromList([4, 5]);
    var other = Uint8List.fromList([1, 2, 3, 4, 5]);
    expect(ByteUtil.combine([first, second, third]), other);
  });

  test('ByteUtil.shortToByteArray() convert short to UintList8', () {
    var value1 = 100;
    expect(ByteUtil.shortToByteArray(value1), Uint8List.fromList([0, 100]));
    var value2 = 1024;
    expect(ByteUtil.shortToByteArray(value2), Uint8List.fromList([4, 1024]));
  });

  test('ByteUtil.intToByteArray() convert int to UintList8', () {
    var value1 = 100;
    expect(ByteUtil.intToByteArray(value1), Uint8List.fromList([0, 0, 0, 100]));
    var value2 = 1024;
    expect(ByteUtil.intToByteArray(value2), Uint8List.fromList([0, 0, 4, 0]));
  });

  test('ByteUtil.trim() sublist Uint8List from 0 to specification length', () {
    var input = Uint8List.fromList([1, 2, 3, 4, 5]);
    expect(ByteUtil.trim(input, 3), Uint8List.fromList([1, 2, 3]));
    expect(ByteUtil.trim(input, 0), Uint8List.fromList([]));
  });

  test('ByteUtil.split() splits the string to three length', () {
    var input = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    var first = Uint8List.fromList([1]);
    var second = Uint8List.fromList([2, 3]);
    var third = Uint8List.fromList([4, 5, 6, 7, 8, 9]);
    expect(ByteUtil.split(input, 1, 2, 6), ([first, second, third]));
  });

  test('ByteUtil.splitTwo() splits the string to two length', () {
    var input = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    var first = Uint8List.fromList([1]);
    var second = Uint8List.fromList([2, 3, 4, 5, 6, 7]);
    expect(ByteUtil.splitTwo(input, 1, 6), [first, second]);
  });

  test('String.trim() removes surrounding whitespace', () {
    var string = '  foo ';
    expect(string.trim(), equals('foo'));
  });

  test('ByteUtil.intsToByteHighAndLow()', () {
    var highValue1 = 4;
    var lowValue1 = 2;
    expect(ByteUtil.intsToByteHighAndLow(highValue1, lowValue1), 66);
    var highValue2 = 2;
    var lowValue2 = 4;
    expect(ByteUtil.intsToByteHighAndLow(highValue2, lowValue2), 36);
    var highValue3 = 3;
    var lowValue3 = 3;
    expect(ByteUtil.intsToByteHighAndLow(highValue3, lowValue3), 51);
  });

  test('ByteUtil.highBitsToInt', () {
    var int1 = 16;
    expect(ByteUtil.highBitsToInt(int1), 1);
    var int2 = 35;
    expect(ByteUtil.highBitsToInt(int2), 2);
    var int3 = 100;
    expect(ByteUtil.highBitsToInt(int3), 6);
  });

  test('ByteUtil.lowBitsToInt', () {
    var int1 = 16;
    expect(ByteUtil.lowBitsToInt(int1), 0);
    var int2 = 35;
    expect(ByteUtil.lowBitsToInt(int2), 3);
    var int3 = 100;
    expect(ByteUtil.lowBitsToInt(int3), 4);
  });

  test('ByteUtil.highBitsToMedium', () {
    var int1 = 16;
    expect(ByteUtil.highBitsToMedium(int1), 0);
    var int2 = 35;
    expect(ByteUtil.highBitsToMedium(int2), 0);
    var int3 = 100;
    expect(ByteUtil.highBitsToMedium(int3), 0);
    var int4 = 10000;
    expect(ByteUtil.highBitsToMedium(int4), 2);
  });

  test('ByteUtil.lowBitsToMedium', () {
    var int1 = 16;
    expect(ByteUtil.lowBitsToMedium(int1), 16);
    var int2 = 35;
    expect(ByteUtil.lowBitsToMedium(int2), 35);
    var int3 = 100;
    expect(ByteUtil.lowBitsToMedium(int3), 100);
    var int4 = 10000;
    expect(ByteUtil.lowBitsToMedium(int4), 1808);
  });

  test('ByteUtil.byteArray5ToLong', () {
    var input = Uint8List.fromList(
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    // TODO
  });
}

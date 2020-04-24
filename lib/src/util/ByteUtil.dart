import 'dart:typed_data';

import 'package:convert/convert.dart';

class ByteUtil {
  static Uint8List trim(Uint8List input, int length) {
    var result = [length];
    result.addAll(input);
    return result;
  }

  static List<Uint8List> splitTwo(
      Uint8List input, int firstLength, int secondLength) {
    var first = input.sublist(0, firstLength);
    var second = input.sublist(firstLength, firstLength + secondLength);
    return [first, second];
  }

  static List<Uint8List> split(
      Uint8List input, int firstLength, int secondLength, int thirdLength) {
    if (input == null ||
        firstLength < 0 ||
        secondLength < 0 ||
        thirdLength < 0 ||
        input.length < firstLength + secondLength + thirdLength) {
      throw ("Input too small: " + (input == null ? null : hex.encode(input)));
    }
    var first = input.sublist(0, firstLength);
    var second = input.sublist(firstLength, firstLength + secondLength);
    var third = input.sublist(
        firstLength + secondLength, firstLength + secondLength + thirdLength);
    return [first, second, third];
  }

  static int intsToByteHighAndLow(int highValue, int lowValue) {
    return ((highValue << 4 | lowValue) & 0xFF);
  }

  static int highBitsToInt(int value) {
    return (value & 0xFF) >> 4;
  }

  static int lowBitsToInt(int value) {
    return (value & 0xF);
  }

  static int highBitsToMedium(int value) {
    return (value >> 12);
  }

  static int lowBitsToMedium(int value) {
    return (value & 0xFFF);
  }

  static int byteArray5ToLong(Uint8List bytes, int offset) {
    return ((bytes[offset] & 0xff) << 32) |
        ((bytes[offset + 1] & 0xff) << 24) |
        ((bytes[offset + 2] & 0xff) << 16) |
        ((bytes[offset + 3] & 0xff) << 8) |
        ((bytes[offset + 4] & 0xff));
  }
}

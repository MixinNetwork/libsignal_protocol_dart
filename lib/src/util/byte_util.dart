import 'dart:typed_data';

import 'package:adaptive_number/adaptive_number.dart';
import 'package:convert/convert.dart';

class ByteUtil {
  static Uint8List combine(List<Uint8List> elements) {
    final results = <int>[];
    elements.forEach(results.addAll);
    return Uint8List.fromList(results);
  }

  static Uint8List shortToByteArray(int value) {
    final bytes = Uint8List(2);
    bytes[0] = value >> 8;
    bytes[1] = value;
    return bytes;
  }

  static Uint8List intToByteArray(int value) {
    final bytes = Uint8List(4);
    bytes[0] = value >> 24;
    bytes[1] = value >> 16;
    bytes[2] = value >> 8;
    bytes[3] = value;
    return bytes;
  }

  static Uint8List trim(Uint8List input, int length) =>
      input.sublist(0, length);

  static List<Uint8List> splitTwo(
      Uint8List input, int firstLength, int secondLength) {
    final first = input.sublist(0, firstLength);
    final second = input.sublist(firstLength, firstLength + secondLength);
    return [first, second];
  }

  static List<Uint8List> split(
      Uint8List input, int firstLength, int secondLength, int thirdLength) {
    if (firstLength < 0 ||
        secondLength < 0 ||
        thirdLength < 0 ||
        input.length < firstLength + secondLength + thirdLength) {
      throw Exception('Input too small: ${hex.encode(input)}');
    }
    final first = input.sublist(0, firstLength);
    final second = input.sublist(firstLength, firstLength + secondLength);
    final third = input.sublist(
        firstLength + secondLength, firstLength + secondLength + thirdLength);
    return [first, second, third];
  }

  static int intsToByteHighAndLow(int highValue, int lowValue) =>
      ((highValue << 4) | lowValue) & 0xFF;

  static int highBitsToInt(int value) => (value & 0xFF) >> 4;

  static int lowBitsToInt(int value) => value & 0xF;

  static int highBitsToMedium(int value) => value >> 12;

  static int lowBitsToMedium(int value) => value & 0xFFF;

  static int byteArray5ToLong(Uint8List bytes, int offset) {
    final v1 = (Number(bytes[offset]) & Number(0xff)) << 32;
    final v2 = (Number(bytes[offset + 1]) & Number(0xff)) << 24;
    final v3 = (Number(bytes[offset + 2]) & Number(0xff)) << 16;
    final v4 = (Number(bytes[offset + 3]) & Number(0xff)) << 8;
    final v5 = Number(bytes[offset + 4]) & Number(0xff);
    return (v1 | v2 | v3 | v4 | v5).intValue;
  }

  static int compare(Uint8List left, Uint8List right) {
    for (var i = 0, j = 0; i < left.length && j < right.length; i++, j++) {
      final a = left[i] & 0xff;
      final b = right[j] & 0xff;

      if (a != b) {
        return a - b;
      }
    }

    return left.length - right.length;
  }
}

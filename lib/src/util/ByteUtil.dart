import 'dart:typed_data';

class ByteUtil {

  static Uint8List trim(Uint8List input, int length) {
    var result = [length];
    result.addAll(input);
    return result;
  }

  static int byteArray5ToLong(Uint8List bytes, int offset) {
    return
      ((bytes[offset]     & 0xff) << 32) |
      ((bytes[offset + 1] & 0xff) << 24) |
      ((bytes[offset + 2] & 0xff) << 16) |
      ((bytes[offset + 3] & 0xff) << 8) |
      ((bytes[offset + 4] & 0xff));
  }
}
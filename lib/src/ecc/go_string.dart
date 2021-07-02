import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

class GoString extends Struct {
  Pointer<Uint8>? string;

  @IntPtr()
  int? length;

  @override
  String toString() {
    final units = <int>[];
    if (length == 0) {
      return '';
    }
    for (var i = 0; i < (length ?? 0); ++i) {
      units.add(string?.elementAt(i).value ?? 0);
    }
    return const Utf8Decoder().convert(units);
  }

  static Pointer<GoString> fromString(String string) {
    final List<int> units = const Utf8Encoder().convert(string);
    final ptr = calloc<Uint8>(units.length);
    for (var i = 0; i < units.length; ++i) {
      ptr.elementAt(i).value = units[i];
    }
    final str = calloc<GoString>().ref;
    // ignore: cascade_invocations
    str.length = units.length;
    // ignore: cascade_invocations
    str.string = ptr;
    return str.addressOf;
  }
}
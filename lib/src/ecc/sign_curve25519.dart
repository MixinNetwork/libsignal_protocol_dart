import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ffi/ffi.dart';

import 'dylib_utils.dart';
import 'go_string.dart';

typedef signSignature = Void Function(
    Pointer<GoString>,
    Pointer<GoString>,
    Pointer<GoString>,
    );
typedef SignSignature = void Function(
    Pointer<GoString>, Pointer<GoString>, Pointer<GoString>);

typedef verifySignature = Int8 Function(
    Pointer<GoString>, Pointer<GoString>, Pointer<GoString>);
typedef VerifySignature = int Function(
    Pointer<GoString>, Pointer<GoString>, Pointer<GoString>);

final libsignal =
dlopenPlatformSpecific('godart', path: Platform.script.resolve('').path);

Uint8List sign(Uint8List privateKey, Uint8List message) {
  final p = hex.encode(privateKey);
  final m = hex.encode(message);
  final signFunction = libsignal
      .lookup<NativeFunction<signSignature>>('SignSignature')
      .asFunction<SignSignature>();

  final private = GoString.fromString(p);
  final msg = GoString.fromString(m);
  final result = GoString.fromString('');
  signFunction(private, msg, result);
  final sig = result.ref;
  calloc.free(private);
  calloc.free(msg);
  final retVal = hex.decode(sig.toString());
  calloc.free(result);
  return Uint8List.fromList(retVal);
}

bool verify(Uint8List publicKey, Uint8List message, Uint8List signature) {
  final p = hex.encode(publicKey);
  final m = hex.encode(message);
  final s = hex.encode(signature);
  final verifyFunction = libsignal
      .lookup<NativeFunction<verifySignature>>('VerifySignature')
      .asFunction<VerifySignature>();
  final public = GoString.fromString(p);
  final msg = GoString.fromString(m);
  final sig = GoString.fromString(s);
  final r = verifyFunction(public, msg, sig);
  calloc.free(public);
  calloc.free(msg);
  calloc.free(sig);
  return r == 1;
}
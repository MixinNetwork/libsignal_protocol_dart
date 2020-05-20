import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:convert/convert.dart';
import 'GoString.dart';
import 'dylib_utils.dart';

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

Uint8List sign(Uint8List privateKey, Uint8List message) {
  final p = hex.encode(privateKey);
  final m = hex.encode(message);
  final libsignal =
      dlopenPlatformSpecific('godart', path: Platform.script.resolve('').path);
  final signFunction = libsignal
      .lookup<NativeFunction<signSignature>>('SignSignature')
      .asFunction<SignSignature>();

  final private = GoString.fromString(p);
  final msg = GoString.fromString(m);
  final result = GoString.fromString('');
  signFunction(private, msg, result);
  final sig = result.ref;
  free(private);
  free(msg);
  free(result);
  return hex.decode(sig.toString());
}

bool verify(Uint8List publicKey, Uint8List message, Uint8List signature) {
  final p = hex.encode(publicKey);
  final m = hex.encode(message);
  final s = hex.encode(signature);
  final libsignal =
      dlopenPlatformSpecific('godart', path: Platform.script.resolve('').path);
  final verifyFunction = libsignal
      .lookup<NativeFunction<verifySignature>>('VerifySignature')
      .asFunction<VerifySignature>();
  final public = GoString.fromString(p);
  final msg = GoString.fromString(m);
  final sig = GoString.fromString(s);
  final r = verifyFunction(public, msg, sig);
  free(public);
  free(msg);
  free(sig);
  return r == 1;
}

import 'package:libsignalprotocoldart/src/IdentityKey.dart';

class UntrustedIdentityException implements Exception {
  final String name;
  final IdentityKey key;

  UntrustedIdentityException(this.name, this.key);
}

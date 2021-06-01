import 'identity_key.dart';

class UntrustedIdentityException implements Exception {
  UntrustedIdentityException(this.name, this.key);

  final String name;
  final IdentityKey? key;
}

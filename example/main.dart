import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

void main() {
  var identityKeyPair = KeyHelper.generateIdentityKeyPair();
  var registerationId = KeyHelper.generateRegistrationId(false);

  var preKeys = KeyHelper.generatePreKeys(0, 110);
  for (var p in preKeys) {
    print(p.id);
  }
}

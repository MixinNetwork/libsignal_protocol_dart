import 'dart:typed_data';

import 'Curve.dart';
import 'ECPrivateKey.dart';

class DjbECPrivateKey extends ECPrivateKey {
  Uint8List privateKey;

  DjbECPrivateKey(Uint8List privateKey) {
    this.privateKey = privateKey;
  }

  @override
  int getType() {
    return Curve.djbType;
  }

  @override
  Uint8List serialize() {
    return privateKey;
  }

  Uint8List getPrivateKey() {
    return privateKey;
  }
}

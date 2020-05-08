import 'dart:typed_data';

import 'Curve.dart';
import 'ECPrivateKey.dart';

class DjbECPrivateKey extends ECPrivateKey {
  final Uint8List _privateKey;

  DjbECPrivateKey(this._privateKey);

  @override
  int getType() {
    return Curve.djbType;
  }

  @override
  Uint8List serialize() {
    return privateKey;
  }

  Uint8List get privateKey => _privateKey;
}

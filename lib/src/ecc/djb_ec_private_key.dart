import 'dart:typed_data';

import 'curve.dart';
import 'ec_private_key.dart';

class DjbECPrivateKey extends ECPrivateKey {
  DjbECPrivateKey(this._privateKey);

  final Uint8List _privateKey;

  @override
  int getType() => Curve.djbType;

  @override
  Uint8List serialize() => privateKey;

  Uint8List get privateKey => _privateKey;
}

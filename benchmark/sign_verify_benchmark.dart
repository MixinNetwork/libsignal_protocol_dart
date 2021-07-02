import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/ecc/ec_key_pair.dart';

import 'rate_benchmark.dart';

class SignVerifyBenchmark extends RateBenchmark {
  SignVerifyBenchmark(bool forSigning, [int dataLength = 1024 * 1024])
      : _forSigning = forSigning,
        _data = Uint8List(dataLength),
        super('Dart - ${forSigning ? 'sign' : 'verify'}');

  final Uint8List _data;
  final bool _forSigning;
  late final ECKeyPair _keyPair;
  Uint8List? _signature;

  @override
  void setup() {
    _keyPair = Curve.generateKeyPair();
    _signature = Curve.calculateSignature(_keyPair.privateKey, _data);
  }

  @override
  void run() {
    if (_forSigning) {
      _signature = Curve.calculateSignature(_keyPair.privateKey, _data);
    } else if (_signature != null) {
      Curve.verifySignature(_keyPair.publicKey, _data, _signature);
    }
    addSample(_data.length);
  }
}

void main() {
  SignVerifyBenchmark(true).report();
  SignVerifyBenchmark(false).report();
}

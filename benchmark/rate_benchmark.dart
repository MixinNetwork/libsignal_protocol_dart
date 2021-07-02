import 'package:benchmark_harness/benchmark_harness.dart';

abstract class RateBenchmark extends BenchmarkBase {
  RateBenchmark(String name, {this.runLength = 5000})
      : super(name, emitter: RateEmitter()) {
    (emitter as RateEmitter).benchmark = this;
  }

  final int runLength;
  int _totalData = 0;
  int _iterations = 0;

  @override
  ScoreEmitter get emitter => super.emitter; // ignore: unnecessary_overrides

  void addSample(int processedData) {
    _totalData += processedData;
  }

  @override
  void exercise() {
    _totalData = 0;
    _iterations = 0;

    final watch = Stopwatch()..start();
    while (watch.elapsedMilliseconds < runLength) {
      run();
      _iterations++;
    }
  }
}

class RateEmitter implements ScoreEmitter {
  late RateBenchmark benchmark;

  int get totalData => benchmark._totalData;
  int get iterations => benchmark._iterations;

  @override
  void emit(String testName, double value) {
    final ms = value / 1000;
    final s = ms / 1000;
    final date = DateTime.now().toString().split('.')[0];

    // ignore: avoid_print
    print('| $date | '
        '$testName | '
        '${_formatDataLength(totalData / s)}/s | '
        '$iterations iterations | '
        '${ms.toInt()} ms | '
        '${_formatDataLength(totalData)} |');
  }

  String _formatDataLength(num dataLen) {
    if (dataLen < 1024) {
      return '${dataLen.toStringAsFixed(2)} B';
    } else if (dataLen < (1024 * 1024)) {
      return '${(dataLen / 1024).toStringAsFixed(2)} KB';
    } else if (dataLen < (1024 * 1024 * 1024)) {
      return '${(dataLen / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(dataLen / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}

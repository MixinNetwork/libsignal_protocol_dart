class FingerprintParsingException implements Exception {
  final _message;

  FingerprintParsingException(this._message);

  @override
  String toString() => '$runtimeType - $_message';
}

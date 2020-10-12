class InvalidMacException implements Exception {
  final String detailMessage;
  InvalidMacException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

class InvalidMessageException implements Exception {
  InvalidMessageException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => '$runtimeType - $detailMessage';
}

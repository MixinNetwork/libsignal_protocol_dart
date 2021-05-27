class InvalidMessageException implements Exception {
  final String detailMessage;
  InvalidMessageException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

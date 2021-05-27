class LegacyMessageException implements Exception {
  final String detailMessage;
  LegacyMessageException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

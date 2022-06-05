class LegacyMessageException implements Exception {
  LegacyMessageException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => 'LegacyMessageException - $detailMessage';
}

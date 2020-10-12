class DuplicateMessageException implements Exception {
  final String detailMessage;
  DuplicateMessageException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

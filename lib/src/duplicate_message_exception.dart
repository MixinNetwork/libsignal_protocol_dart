class DuplicateMessageException implements Exception {
  DuplicateMessageException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => 'DuplicateMessageException - $detailMessage';
}

class DuplicateMessageException implements Exception {
  final String detailMessage;
  DuplicateMessageException(this.detailMessage);
}
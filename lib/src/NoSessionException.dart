class NoSessionException implements Exception {
  final String detailMessage;
  NoSessionException(this.detailMessage);
}

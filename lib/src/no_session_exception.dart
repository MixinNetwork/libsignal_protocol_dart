class NoSessionException implements Exception {
  NoSessionException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => '$runtimeType - $detailMessage';
}

class NoSessionException implements Exception {
  final String detailMessage;
  NoSessionException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

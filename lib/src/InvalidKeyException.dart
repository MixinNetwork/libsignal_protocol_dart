class InvalidKeyException implements Exception {
  final String detailMessage;
  InvalidKeyException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

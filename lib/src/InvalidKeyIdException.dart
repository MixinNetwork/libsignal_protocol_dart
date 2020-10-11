class InvalidKeyIdException implements Exception {
  final String detailMessage;
  InvalidKeyIdException(this.detailMessage);

  @override
  String toString() => '$runtimeType - $detailMessage';
}

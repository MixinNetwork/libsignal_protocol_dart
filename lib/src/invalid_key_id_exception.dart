class InvalidKeyIdException implements Exception {
  InvalidKeyIdException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => '$runtimeType - $detailMessage';
}

class InvalidKeyException implements Exception {
  InvalidKeyException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => 'InvalidKeyException - $detailMessage';
}

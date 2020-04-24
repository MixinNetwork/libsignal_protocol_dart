class FingerprintVersionMismatchException implements Exception {
  int _theirVersion;
  int _ourVersion;

  FingerprintVersionMismatchException(int theirVersion, int ourVersion) {
    _theirVersion = theirVersion;
    _ourVersion = ourVersion;
  }
}
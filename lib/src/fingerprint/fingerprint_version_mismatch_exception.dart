class FingerprintVersionMismatchException implements Exception {
  FingerprintVersionMismatchException(this._theirVersion, this._ourVersion);

  final int _theirVersion;
  final int _ourVersion;
}

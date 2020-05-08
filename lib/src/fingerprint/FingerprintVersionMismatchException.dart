class FingerprintVersionMismatchException implements Exception {
  final int _theirVersion;
  final int _ourVersion;

  FingerprintVersionMismatchException(this._theirVersion, this._ourVersion);
}

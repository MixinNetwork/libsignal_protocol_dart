class FingerprintVersionMismatchException implements Exception {
  int _theirVersion;
  int _ourVersion;

  FingerprintVersionMismatchException(this._theirVersion, this._ourVersion);
}
class FingerprintVersionMismatchException implements Exception {
  FingerprintVersionMismatchException(this._theirVersion, this._ourVersion);

  // ignore: unused_field
  final int _theirVersion;
  // ignore: unused_field
  final int _ourVersion;
}

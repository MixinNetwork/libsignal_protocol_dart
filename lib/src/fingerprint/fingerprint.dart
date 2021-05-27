import 'displayable_fingerprint.dart';
import 'scannable_fingerprint.dart';

class Fingerprint {
  Fingerprint(this._displayableFingerprint, this._scannableFingerprint);

  final DisplayableFingerprint _displayableFingerprint;
  final ScannableFingerprint _scannableFingerprint;

  DisplayableFingerprint get displayableFingerprint => _displayableFingerprint;
  ScannableFingerprint get scannableFingerprint => _scannableFingerprint;
}

import 'DisplayableFingerprint.dart';
import 'ScannableFingerprint.dart';

class Fingerprint {
  DisplayableFingerprint _displayableFingerprint;
  ScannableFingerprint _scannableFingerprint;

  Fingerprint(this._displayableFingerprint, this._scannableFingerprint);

  DisplayableFingerprint get displayableFingerprint => _displayableFingerprint;
  ScannableFingerprint get scannableFingerprint => _scannableFingerprint;
}
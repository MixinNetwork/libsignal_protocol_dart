import 'package:libsignalprotocoldart/src/fingerprint/DisplayableFingerprint.dart';
import 'package:libsignalprotocoldart/src/fingerprint/ScannableFingerprint.dart';

class Fingerprint {
  DisplayableFingerprint _displayableFingerprint;
  ScannableFingerprint _scannableFingerprint;

  Fingerprint(DisplayableFingerprint displayableFingerprint, ScannableFingerprint scannableFingerprint) {
    _displayableFingerprint = displayableFingerprint;
    _scannableFingerprint = scannableFingerprint;
  }

  DisplayableFingerprint get displayableFingerprint => _displayableFingerprint;
  ScannableFingerprint get scannableFingerprint => _scannableFingerprint;
}
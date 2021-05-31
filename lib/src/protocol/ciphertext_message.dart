import 'dart:typed_data';

abstract class CiphertextMessage {
  static const int currentVersion = 3;

  static const int whisperType = 2;
  static const int prekeyType = 3;
  static const int senderKeyType = 4;
  static const int senderKeyDistributionType = 5;

  // This should be the worst case (worse than V2).  So not always accurate, but good enough for padding.
  static const int encryptedMessageOverhead = 53;

  Uint8List serialize();
  int getType();
}

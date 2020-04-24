import 'dart:typed_data';

abstract class CiphertextMessage {
  static final int CURRENT_VERSION = 3;

  static final int WHISPER_TYPE = 2;
  static final int PREKEY_TYPE = 3;
  static final int SENDERKEY_TYPE = 4;
  static final int SENDERKEY_DISTRIBUTION_TYPE = 5;

  // This should be the worst case (worse than V2).  So not always accurate, but good enough for padding.
  static final int ENCRYPTED_MESSAGE_OVERHEAD = 53;

  Uint8List serialize();
  int getType();
}

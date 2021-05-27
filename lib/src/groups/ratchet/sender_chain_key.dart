import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'sender_message_key.dart';

class SenderChainKey {
  SenderChainKey(this._iteration, this._chainKey);

  static final Uint8List _MESSAGE_KEY_SEED = Uint8List.fromList([0x01]);
  static final Uint8List _CHAIN_KEY_SEED = Uint8List.fromList([0x02]);

  final int _iteration;
  final Uint8List _chainKey;

  int get iteration => _iteration;

  Uint8List get seed => _chainKey;

  SenderMessageKey get senderMessageKey =>
      SenderMessageKey(_iteration, getDerivative(_MESSAGE_KEY_SEED, _chainKey));

  SenderChainKey get next =>
      SenderChainKey(_iteration + 1, getDerivative(_CHAIN_KEY_SEED, _chainKey));

  Uint8List getDerivative(Uint8List seed, Uint8List key) {
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(seed);
    return Uint8List.fromList(digest.bytes);
  }
}

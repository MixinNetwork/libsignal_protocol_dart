///
//  Generated code. Do not modify.
//  source: WhisperTextProtocol.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const SignalMessage$json = const {
  '1': 'SignalMessage',
  '2': const [
    const {'1': 'ratchetKey', '3': 1, '4': 1, '5': 12, '10': 'ratchetKey'},
    const {'1': 'counter', '3': 2, '4': 1, '5': 13, '10': 'counter'},
    const {'1': 'previousCounter', '3': 3, '4': 1, '5': 13, '10': 'previousCounter'},
    const {'1': 'ciphertext', '3': 4, '4': 1, '5': 12, '10': 'ciphertext'},
  ],
};

const PreKeySignalMessage$json = const {
  '1': 'PreKeySignalMessage',
  '2': const [
    const {'1': 'registrationId', '3': 5, '4': 1, '5': 13, '10': 'registrationId'},
    const {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    const {'1': 'signedPreKeyId', '3': 6, '4': 1, '5': 13, '10': 'signedPreKeyId'},
    const {'1': 'baseKey', '3': 2, '4': 1, '5': 12, '10': 'baseKey'},
    const {'1': 'identityKey', '3': 3, '4': 1, '5': 12, '10': 'identityKey'},
    const {'1': 'message', '3': 4, '4': 1, '5': 12, '10': 'message'},
  ],
};

const KeyExchangeMessage$json = const {
  '1': 'KeyExchangeMessage',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'baseKey', '3': 2, '4': 1, '5': 12, '10': 'baseKey'},
    const {'1': 'ratchetKey', '3': 3, '4': 1, '5': 12, '10': 'ratchetKey'},
    const {'1': 'identityKey', '3': 4, '4': 1, '5': 12, '10': 'identityKey'},
    const {'1': 'baseKeySignature', '3': 5, '4': 1, '5': 12, '10': 'baseKeySignature'},
  ],
};

const SenderKeyMessage$json = const {
  '1': 'SenderKeyMessage',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'iteration', '3': 2, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'ciphertext', '3': 3, '4': 1, '5': 12, '10': 'ciphertext'},
  ],
};

const SenderKeyDistributionMessage$json = const {
  '1': 'SenderKeyDistributionMessage',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'iteration', '3': 2, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'chainKey', '3': 3, '4': 1, '5': 12, '10': 'chainKey'},
    const {'1': 'signingKey', '3': 4, '4': 1, '5': 12, '10': 'signingKey'},
  ],
};

const DeviceConsistencyCodeMessage$json = const {
  '1': 'DeviceConsistencyCodeMessage',
  '2': const [
    const {'1': 'generation', '3': 1, '4': 1, '5': 13, '10': 'generation'},
    const {'1': 'signature', '3': 2, '4': 1, '5': 12, '10': 'signature'},
  ],
};


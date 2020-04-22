///
//  Generated code. Do not modify.
//  source: LocalStorageProtocol.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const SessionStructure$json = const {
  '1': 'SessionStructure',
  '2': const [
    const {'1': 'sessionVersion', '3': 1, '4': 1, '5': 13, '10': 'sessionVersion'},
    const {'1': 'localIdentityPublic', '3': 2, '4': 1, '5': 12, '10': 'localIdentityPublic'},
    const {'1': 'remoteIdentityPublic', '3': 3, '4': 1, '5': 12, '10': 'remoteIdentityPublic'},
    const {'1': 'rootKey', '3': 4, '4': 1, '5': 12, '10': 'rootKey'},
    const {'1': 'previousCounter', '3': 5, '4': 1, '5': 13, '10': 'previousCounter'},
    const {'1': 'senderChain', '3': 6, '4': 1, '5': 11, '6': '.textsecure.SessionStructure.Chain', '10': 'senderChain'},
    const {'1': 'receiverChains', '3': 7, '4': 3, '5': 11, '6': '.textsecure.SessionStructure.Chain', '10': 'receiverChains'},
    const {'1': 'pendingKeyExchange', '3': 8, '4': 1, '5': 11, '6': '.textsecure.SessionStructure.PendingKeyExchange', '10': 'pendingKeyExchange'},
    const {'1': 'pendingPreKey', '3': 9, '4': 1, '5': 11, '6': '.textsecure.SessionStructure.PendingPreKey', '10': 'pendingPreKey'},
    const {'1': 'remoteRegistrationId', '3': 10, '4': 1, '5': 13, '10': 'remoteRegistrationId'},
    const {'1': 'localRegistrationId', '3': 11, '4': 1, '5': 13, '10': 'localRegistrationId'},
    const {'1': 'needsRefresh', '3': 12, '4': 1, '5': 8, '10': 'needsRefresh'},
    const {'1': 'aliceBaseKey', '3': 13, '4': 1, '5': 12, '10': 'aliceBaseKey'},
  ],
  '3': const [SessionStructure_Chain$json, SessionStructure_PendingKeyExchange$json, SessionStructure_PendingPreKey$json],
};

const SessionStructure_Chain$json = const {
  '1': 'Chain',
  '2': const [
    const {'1': 'senderRatchetKey', '3': 1, '4': 1, '5': 12, '10': 'senderRatchetKey'},
    const {'1': 'senderRatchetKeyPrivate', '3': 2, '4': 1, '5': 12, '10': 'senderRatchetKeyPrivate'},
    const {'1': 'chainKey', '3': 3, '4': 1, '5': 11, '6': '.textsecure.SessionStructure.Chain.ChainKey', '10': 'chainKey'},
    const {'1': 'messageKeys', '3': 4, '4': 3, '5': 11, '6': '.textsecure.SessionStructure.Chain.MessageKey', '10': 'messageKeys'},
  ],
  '3': const [SessionStructure_Chain_ChainKey$json, SessionStructure_Chain_MessageKey$json],
};

const SessionStructure_Chain_ChainKey$json = const {
  '1': 'ChainKey',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'key', '3': 2, '4': 1, '5': 12, '10': 'key'},
  ],
};

const SessionStructure_Chain_MessageKey$json = const {
  '1': 'MessageKey',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'cipherKey', '3': 2, '4': 1, '5': 12, '10': 'cipherKey'},
    const {'1': 'macKey', '3': 3, '4': 1, '5': 12, '10': 'macKey'},
    const {'1': 'iv', '3': 4, '4': 1, '5': 12, '10': 'iv'},
  ],
};

const SessionStructure_PendingKeyExchange$json = const {
  '1': 'PendingKeyExchange',
  '2': const [
    const {'1': 'sequence', '3': 1, '4': 1, '5': 13, '10': 'sequence'},
    const {'1': 'localBaseKey', '3': 2, '4': 1, '5': 12, '10': 'localBaseKey'},
    const {'1': 'localBaseKeyPrivate', '3': 3, '4': 1, '5': 12, '10': 'localBaseKeyPrivate'},
    const {'1': 'localRatchetKey', '3': 4, '4': 1, '5': 12, '10': 'localRatchetKey'},
    const {'1': 'localRatchetKeyPrivate', '3': 5, '4': 1, '5': 12, '10': 'localRatchetKeyPrivate'},
    const {'1': 'localIdentityKey', '3': 7, '4': 1, '5': 12, '10': 'localIdentityKey'},
    const {'1': 'localIdentityKeyPrivate', '3': 8, '4': 1, '5': 12, '10': 'localIdentityKeyPrivate'},
  ],
};

const SessionStructure_PendingPreKey$json = const {
  '1': 'PendingPreKey',
  '2': const [
    const {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    const {'1': 'signedPreKeyId', '3': 3, '4': 1, '5': 5, '10': 'signedPreKeyId'},
    const {'1': 'baseKey', '3': 2, '4': 1, '5': 12, '10': 'baseKey'},
  ],
};

const RecordStructure$json = const {
  '1': 'RecordStructure',
  '2': const [
    const {'1': 'currentSession', '3': 1, '4': 1, '5': 11, '6': '.textsecure.SessionStructure', '10': 'currentSession'},
    const {'1': 'previousSessions', '3': 2, '4': 3, '5': 11, '6': '.textsecure.SessionStructure', '10': 'previousSessions'},
  ],
};

const PreKeyRecordStructure$json = const {
  '1': 'PreKeyRecordStructure',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'publicKey', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 12, '10': 'privateKey'},
  ],
};

const SignedPreKeyRecordStructure$json = const {
  '1': 'SignedPreKeyRecordStructure',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'publicKey', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 12, '10': 'privateKey'},
    const {'1': 'signature', '3': 4, '4': 1, '5': 12, '10': 'signature'},
    const {'1': 'timestamp', '3': 5, '4': 1, '5': 6, '10': 'timestamp'},
  ],
};

const IdentityKeyPairStructure$json = const {
  '1': 'IdentityKeyPairStructure',
  '2': const [
    const {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 2, '4': 1, '5': 12, '10': 'privateKey'},
  ],
};

const SenderKeyStateStructure$json = const {
  '1': 'SenderKeyStateStructure',
  '2': const [
    const {'1': 'senderKeyId', '3': 1, '4': 1, '5': 13, '10': 'senderKeyId'},
    const {'1': 'senderChainKey', '3': 2, '4': 1, '5': 11, '6': '.textsecure.SenderKeyStateStructure.SenderChainKey', '10': 'senderChainKey'},
    const {'1': 'senderSigningKey', '3': 3, '4': 1, '5': 11, '6': '.textsecure.SenderKeyStateStructure.SenderSigningKey', '10': 'senderSigningKey'},
    const {'1': 'senderMessageKeys', '3': 4, '4': 3, '5': 11, '6': '.textsecure.SenderKeyStateStructure.SenderMessageKey', '10': 'senderMessageKeys'},
  ],
  '3': const [SenderKeyStateStructure_SenderChainKey$json, SenderKeyStateStructure_SenderMessageKey$json, SenderKeyStateStructure_SenderSigningKey$json],
};

const SenderKeyStateStructure_SenderChainKey$json = const {
  '1': 'SenderChainKey',
  '2': const [
    const {'1': 'iteration', '3': 1, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'seed', '3': 2, '4': 1, '5': 12, '10': 'seed'},
  ],
};

const SenderKeyStateStructure_SenderMessageKey$json = const {
  '1': 'SenderMessageKey',
  '2': const [
    const {'1': 'iteration', '3': 1, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'seed', '3': 2, '4': 1, '5': 12, '10': 'seed'},
  ],
};

const SenderKeyStateStructure_SenderSigningKey$json = const {
  '1': 'SenderSigningKey',
  '2': const [
    const {'1': 'public', '3': 1, '4': 1, '5': 12, '10': 'public'},
    const {'1': 'private', '3': 2, '4': 1, '5': 12, '10': 'private'},
  ],
};

const SenderKeyRecordStructure$json = const {
  '1': 'SenderKeyRecordStructure',
  '2': const [
    const {'1': 'senderKeyStates', '3': 1, '4': 3, '5': 11, '6': '.textsecure.SenderKeyStateStructure', '10': 'senderKeyStates'},
  ],
};


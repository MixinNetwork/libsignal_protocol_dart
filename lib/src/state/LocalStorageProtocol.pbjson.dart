///
//  Generated code. Do not modify.
//  source: LocalStorageProtocol.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use sessionStructureDescriptor instead')
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

@$core.Deprecated('Use sessionStructureDescriptor instead')
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

@$core.Deprecated('Use sessionStructureDescriptor instead')
const SessionStructure_Chain_ChainKey$json = const {
  '1': 'ChainKey',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'key', '3': 2, '4': 1, '5': 12, '10': 'key'},
  ],
};

@$core.Deprecated('Use sessionStructureDescriptor instead')
const SessionStructure_Chain_MessageKey$json = const {
  '1': 'MessageKey',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'cipherKey', '3': 2, '4': 1, '5': 12, '10': 'cipherKey'},
    const {'1': 'macKey', '3': 3, '4': 1, '5': 12, '10': 'macKey'},
    const {'1': 'iv', '3': 4, '4': 1, '5': 12, '10': 'iv'},
  ],
};

@$core.Deprecated('Use sessionStructureDescriptor instead')
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

@$core.Deprecated('Use sessionStructureDescriptor instead')
const SessionStructure_PendingPreKey$json = const {
  '1': 'PendingPreKey',
  '2': const [
    const {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    const {'1': 'signedPreKeyId', '3': 3, '4': 1, '5': 5, '10': 'signedPreKeyId'},
    const {'1': 'baseKey', '3': 2, '4': 1, '5': 12, '10': 'baseKey'},
  ],
};

/// Descriptor for `SessionStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionStructureDescriptor = $convert.base64Decode('ChBTZXNzaW9uU3RydWN0dXJlEiYKDnNlc3Npb25WZXJzaW9uGAEgASgNUg5zZXNzaW9uVmVyc2lvbhIwChNsb2NhbElkZW50aXR5UHVibGljGAIgASgMUhNsb2NhbElkZW50aXR5UHVibGljEjIKFHJlbW90ZUlkZW50aXR5UHVibGljGAMgASgMUhRyZW1vdGVJZGVudGl0eVB1YmxpYxIYCgdyb290S2V5GAQgASgMUgdyb290S2V5EigKD3ByZXZpb3VzQ291bnRlchgFIAEoDVIPcHJldmlvdXNDb3VudGVyEkQKC3NlbmRlckNoYWluGAYgASgLMiIudGV4dHNlY3VyZS5TZXNzaW9uU3RydWN0dXJlLkNoYWluUgtzZW5kZXJDaGFpbhJKCg5yZWNlaXZlckNoYWlucxgHIAMoCzIiLnRleHRzZWN1cmUuU2Vzc2lvblN0cnVjdHVyZS5DaGFpblIOcmVjZWl2ZXJDaGFpbnMSXwoScGVuZGluZ0tleUV4Y2hhbmdlGAggASgLMi8udGV4dHNlY3VyZS5TZXNzaW9uU3RydWN0dXJlLlBlbmRpbmdLZXlFeGNoYW5nZVIScGVuZGluZ0tleUV4Y2hhbmdlElAKDXBlbmRpbmdQcmVLZXkYCSABKAsyKi50ZXh0c2VjdXJlLlNlc3Npb25TdHJ1Y3R1cmUuUGVuZGluZ1ByZUtleVINcGVuZGluZ1ByZUtleRIyChRyZW1vdGVSZWdpc3RyYXRpb25JZBgKIAEoDVIUcmVtb3RlUmVnaXN0cmF0aW9uSWQSMAoTbG9jYWxSZWdpc3RyYXRpb25JZBgLIAEoDVITbG9jYWxSZWdpc3RyYXRpb25JZBIiCgxuZWVkc1JlZnJlc2gYDCABKAhSDG5lZWRzUmVmcmVzaBIiCgxhbGljZUJhc2VLZXkYDSABKAxSDGFsaWNlQmFzZUtleRqlAwoFQ2hhaW4SKgoQc2VuZGVyUmF0Y2hldEtleRgBIAEoDFIQc2VuZGVyUmF0Y2hldEtleRI4ChdzZW5kZXJSYXRjaGV0S2V5UHJpdmF0ZRgCIAEoDFIXc2VuZGVyUmF0Y2hldEtleVByaXZhdGUSRwoIY2hhaW5LZXkYAyABKAsyKy50ZXh0c2VjdXJlLlNlc3Npb25TdHJ1Y3R1cmUuQ2hhaW4uQ2hhaW5LZXlSCGNoYWluS2V5Ek8KC21lc3NhZ2VLZXlzGAQgAygLMi0udGV4dHNlY3VyZS5TZXNzaW9uU3RydWN0dXJlLkNoYWluLk1lc3NhZ2VLZXlSC21lc3NhZ2VLZXlzGjIKCENoYWluS2V5EhQKBWluZGV4GAEgASgNUgVpbmRleBIQCgNrZXkYAiABKAxSA2tleRpoCgpNZXNzYWdlS2V5EhQKBWluZGV4GAEgASgNUgVpbmRleBIcCgljaXBoZXJLZXkYAiABKAxSCWNpcGhlcktleRIWCgZtYWNLZXkYAyABKAxSBm1hY0tleRIOCgJpdhgEIAEoDFICaXYazgIKElBlbmRpbmdLZXlFeGNoYW5nZRIaCghzZXF1ZW5jZRgBIAEoDVIIc2VxdWVuY2USIgoMbG9jYWxCYXNlS2V5GAIgASgMUgxsb2NhbEJhc2VLZXkSMAoTbG9jYWxCYXNlS2V5UHJpdmF0ZRgDIAEoDFITbG9jYWxCYXNlS2V5UHJpdmF0ZRIoCg9sb2NhbFJhdGNoZXRLZXkYBCABKAxSD2xvY2FsUmF0Y2hldEtleRI2ChZsb2NhbFJhdGNoZXRLZXlQcml2YXRlGAUgASgMUhZsb2NhbFJhdGNoZXRLZXlQcml2YXRlEioKEGxvY2FsSWRlbnRpdHlLZXkYByABKAxSEGxvY2FsSWRlbnRpdHlLZXkSOAoXbG9jYWxJZGVudGl0eUtleVByaXZhdGUYCCABKAxSF2xvY2FsSWRlbnRpdHlLZXlQcml2YXRlGm0KDVBlbmRpbmdQcmVLZXkSGgoIcHJlS2V5SWQYASABKA1SCHByZUtleUlkEiYKDnNpZ25lZFByZUtleUlkGAMgASgFUg5zaWduZWRQcmVLZXlJZBIYCgdiYXNlS2V5GAIgASgMUgdiYXNlS2V5');
@$core.Deprecated('Use recordStructureDescriptor instead')
const RecordStructure$json = const {
  '1': 'RecordStructure',
  '2': const [
    const {'1': 'currentSession', '3': 1, '4': 1, '5': 11, '6': '.textsecure.SessionStructure', '10': 'currentSession'},
    const {'1': 'previousSessions', '3': 2, '4': 3, '5': 11, '6': '.textsecure.SessionStructure', '10': 'previousSessions'},
  ],
};

/// Descriptor for `RecordStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordStructureDescriptor = $convert.base64Decode('Cg9SZWNvcmRTdHJ1Y3R1cmUSRAoOY3VycmVudFNlc3Npb24YASABKAsyHC50ZXh0c2VjdXJlLlNlc3Npb25TdHJ1Y3R1cmVSDmN1cnJlbnRTZXNzaW9uEkgKEHByZXZpb3VzU2Vzc2lvbnMYAiADKAsyHC50ZXh0c2VjdXJlLlNlc3Npb25TdHJ1Y3R1cmVSEHByZXZpb3VzU2Vzc2lvbnM=');
@$core.Deprecated('Use preKeyRecordStructureDescriptor instead')
const PreKeyRecordStructure$json = const {
  '1': 'PreKeyRecordStructure',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'publicKey', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 12, '10': 'privateKey'},
  ],
};

/// Descriptor for `PreKeyRecordStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preKeyRecordStructureDescriptor = $convert.base64Decode('ChVQcmVLZXlSZWNvcmRTdHJ1Y3R1cmUSDgoCaWQYASABKA1SAmlkEhwKCXB1YmxpY0tleRgCIAEoDFIJcHVibGljS2V5Eh4KCnByaXZhdGVLZXkYAyABKAxSCnByaXZhdGVLZXk=');
@$core.Deprecated('Use signedPreKeyRecordStructureDescriptor instead')
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

/// Descriptor for `SignedPreKeyRecordStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signedPreKeyRecordStructureDescriptor = $convert.base64Decode('ChtTaWduZWRQcmVLZXlSZWNvcmRTdHJ1Y3R1cmUSDgoCaWQYASABKA1SAmlkEhwKCXB1YmxpY0tleRgCIAEoDFIJcHVibGljS2V5Eh4KCnByaXZhdGVLZXkYAyABKAxSCnByaXZhdGVLZXkSHAoJc2lnbmF0dXJlGAQgASgMUglzaWduYXR1cmUSHAoJdGltZXN0YW1wGAUgASgGUgl0aW1lc3RhbXA=');
@$core.Deprecated('Use identityKeyPairStructureDescriptor instead')
const IdentityKeyPairStructure$json = const {
  '1': 'IdentityKeyPairStructure',
  '2': const [
    const {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 2, '4': 1, '5': 12, '10': 'privateKey'},
  ],
};

/// Descriptor for `IdentityKeyPairStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identityKeyPairStructureDescriptor = $convert.base64Decode('ChhJZGVudGl0eUtleVBhaXJTdHJ1Y3R1cmUSHAoJcHVibGljS2V5GAEgASgMUglwdWJsaWNLZXkSHgoKcHJpdmF0ZUtleRgCIAEoDFIKcHJpdmF0ZUtleQ==');
@$core.Deprecated('Use senderKeyStateStructureDescriptor instead')
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

@$core.Deprecated('Use senderKeyStateStructureDescriptor instead')
const SenderKeyStateStructure_SenderChainKey$json = const {
  '1': 'SenderChainKey',
  '2': const [
    const {'1': 'iteration', '3': 1, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'seed', '3': 2, '4': 1, '5': 12, '10': 'seed'},
  ],
};

@$core.Deprecated('Use senderKeyStateStructureDescriptor instead')
const SenderKeyStateStructure_SenderMessageKey$json = const {
  '1': 'SenderMessageKey',
  '2': const [
    const {'1': 'iteration', '3': 1, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'seed', '3': 2, '4': 1, '5': 12, '10': 'seed'},
  ],
};

@$core.Deprecated('Use senderKeyStateStructureDescriptor instead')
const SenderKeyStateStructure_SenderSigningKey$json = const {
  '1': 'SenderSigningKey',
  '2': const [
    const {'1': 'public', '3': 1, '4': 1, '5': 12, '10': 'public'},
    const {'1': 'private', '3': 2, '4': 1, '5': 12, '10': 'private'},
  ],
};

/// Descriptor for `SenderKeyStateStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderKeyStateStructureDescriptor = $convert.base64Decode('ChdTZW5kZXJLZXlTdGF0ZVN0cnVjdHVyZRIgCgtzZW5kZXJLZXlJZBgBIAEoDVILc2VuZGVyS2V5SWQSWgoOc2VuZGVyQ2hhaW5LZXkYAiABKAsyMi50ZXh0c2VjdXJlLlNlbmRlcktleVN0YXRlU3RydWN0dXJlLlNlbmRlckNoYWluS2V5Ug5zZW5kZXJDaGFpbktleRJgChBzZW5kZXJTaWduaW5nS2V5GAMgASgLMjQudGV4dHNlY3VyZS5TZW5kZXJLZXlTdGF0ZVN0cnVjdHVyZS5TZW5kZXJTaWduaW5nS2V5UhBzZW5kZXJTaWduaW5nS2V5EmIKEXNlbmRlck1lc3NhZ2VLZXlzGAQgAygLMjQudGV4dHNlY3VyZS5TZW5kZXJLZXlTdGF0ZVN0cnVjdHVyZS5TZW5kZXJNZXNzYWdlS2V5UhFzZW5kZXJNZXNzYWdlS2V5cxpCCg5TZW5kZXJDaGFpbktleRIcCglpdGVyYXRpb24YASABKA1SCWl0ZXJhdGlvbhISCgRzZWVkGAIgASgMUgRzZWVkGkQKEFNlbmRlck1lc3NhZ2VLZXkSHAoJaXRlcmF0aW9uGAEgASgNUglpdGVyYXRpb24SEgoEc2VlZBgCIAEoDFIEc2VlZBpEChBTZW5kZXJTaWduaW5nS2V5EhYKBnB1YmxpYxgBIAEoDFIGcHVibGljEhgKB3ByaXZhdGUYAiABKAxSB3ByaXZhdGU=');
@$core.Deprecated('Use senderKeyRecordStructureDescriptor instead')
const SenderKeyRecordStructure$json = const {
  '1': 'SenderKeyRecordStructure',
  '2': const [
    const {'1': 'senderKeyStates', '3': 1, '4': 3, '5': 11, '6': '.textsecure.SenderKeyStateStructure', '10': 'senderKeyStates'},
  ],
};

/// Descriptor for `SenderKeyRecordStructure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderKeyRecordStructureDescriptor = $convert.base64Decode('ChhTZW5kZXJLZXlSZWNvcmRTdHJ1Y3R1cmUSTQoPc2VuZGVyS2V5U3RhdGVzGAEgAygLMiMudGV4dHNlY3VyZS5TZW5kZXJLZXlTdGF0ZVN0cnVjdHVyZVIPc2VuZGVyS2V5U3RhdGVz');

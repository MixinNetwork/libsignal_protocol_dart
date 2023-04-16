import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use signalMessageDescriptor instead')
const signalMessage$json = {
  '1': 'SignalMessage',
  '2': [
    {'1': 'ratchetKey', '3': 1, '4': 1, '5': 12, '10': 'ratchetKey'},
    {'1': 'counter', '3': 2, '4': 1, '5': 13, '10': 'counter'},
    {'1': 'previousCounter', '3': 3, '4': 1, '5': 13, '10': 'previousCounter'},
    {'1': 'ciphertext', '3': 4, '4': 1, '5': 12, '10': 'ciphertext'},
  ],
};

/// Descriptor for `SignalMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalMessageDescriptor = $convert.base64Decode(
    'Cg1TaWduYWxNZXNzYWdlEh4KCnJhdGNoZXRLZXkYASABKAxSCnJhdGNoZXRLZXkSGAoHY291bnRlchgCIAEoDVIHY291bnRlchIoCg9wcmV2aW91c0NvdW50ZXIYAyABKA1SD3ByZXZpb3VzQ291bnRlchIeCgpjaXBoZXJ0ZXh0GAQgASgMUgpjaXBoZXJ0ZXh0');
@$core.Deprecated('Use preKeySignalMessageDescriptor instead')
const preKeySignalMessage$json = {
  '1': 'PreKeySignalMessage',
  '2': [
    {'1': 'registrationId', '3': 5, '4': 1, '5': 13, '10': 'registrationId'},
    {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    {'1': 'signedPreKeyId', '3': 6, '4': 1, '5': 13, '10': 'signedPreKeyId'},
    {'1': 'baseKey', '3': 2, '4': 1, '5': 12, '10': 'baseKey'},
    {'1': 'identityKey', '3': 3, '4': 1, '5': 12, '10': 'identityKey'},
    {'1': 'message', '3': 4, '4': 1, '5': 12, '10': 'message'},
  ],
};

/// Descriptor for `PreKeySignalMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preKeySignalMessageDescriptor = $convert.base64Decode(
    'ChNQcmVLZXlTaWduYWxNZXNzYWdlEiYKDnJlZ2lzdHJhdGlvbklkGAUgASgNUg5yZWdpc3RyYXRpb25JZBIaCghwcmVLZXlJZBgBIAEoDVIIcHJlS2V5SWQSJgoOc2lnbmVkUHJlS2V5SWQYBiABKA1SDnNpZ25lZFByZUtleUlkEhgKB2Jhc2VLZXkYAiABKAxSB2Jhc2VLZXkSIAoLaWRlbnRpdHlLZXkYAyABKAxSC2lkZW50aXR5S2V5EhgKB21lc3NhZ2UYBCABKAxSB21lc3NhZ2U=');
@$core.Deprecated('Use keyExchangeMessageDescriptor instead')
const keyExchangeMessage$json = {
  '1': 'KeyExchangeMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'baseKey', '3': 2, '4': 1, '5': 12, '10': 'baseKey'},
    {'1': 'ratchetKey', '3': 3, '4': 1, '5': 12, '10': 'ratchetKey'},
    {'1': 'identityKey', '3': 4, '4': 1, '5': 12, '10': 'identityKey'},
    {
      '1': 'baseKeySignature',
      '3': 5,
      '4': 1,
      '5': 12,
      '10': 'baseKeySignature'
    },
  ],
};

/// Descriptor for `KeyExchangeMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List keyExchangeMessageDescriptor = $convert.base64Decode(
    'ChJLZXlFeGNoYW5nZU1lc3NhZ2USDgoCaWQYASABKA1SAmlkEhgKB2Jhc2VLZXkYAiABKAxSB2Jhc2VLZXkSHgoKcmF0Y2hldEtleRgDIAEoDFIKcmF0Y2hldEtleRIgCgtpZGVudGl0eUtleRgEIAEoDFILaWRlbnRpdHlLZXkSKgoQYmFzZUtleVNpZ25hdHVyZRgFIAEoDFIQYmFzZUtleVNpZ25hdHVyZQ==');
@$core.Deprecated('Use senderKeyMessageDescriptor instead')
const senderKeyMessage$json = {
  '1': 'SenderKeyMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'iteration', '3': 2, '4': 1, '5': 13, '10': 'iteration'},
    {'1': 'ciphertext', '3': 3, '4': 1, '5': 12, '10': 'ciphertext'},
  ],
};

/// Descriptor for `SenderKeyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderKeyMessageDescriptor = $convert.base64Decode(
    'ChBTZW5kZXJLZXlNZXNzYWdlEg4KAmlkGAEgASgNUgJpZBIcCglpdGVyYXRpb24YAiABKA1SCWl0ZXJhdGlvbhIeCgpjaXBoZXJ0ZXh0GAMgASgMUgpjaXBoZXJ0ZXh0');
@$core.Deprecated('Use senderKeyDistributionMessageDescriptor instead')
const senderKeyDistributionMessage$json = {
  '1': 'SenderKeyDistributionMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'iteration', '3': 2, '4': 1, '5': 13, '10': 'iteration'},
    {'1': 'chainKey', '3': 3, '4': 1, '5': 12, '10': 'chainKey'},
    {'1': 'signingKey', '3': 4, '4': 1, '5': 12, '10': 'signingKey'},
  ],
};

/// Descriptor for `SenderKeyDistributionMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderKeyDistributionMessageDescriptor =
    $convert.base64Decode(
        'ChxTZW5kZXJLZXlEaXN0cmlidXRpb25NZXNzYWdlEg4KAmlkGAEgASgNUgJpZBIcCglpdGVyYXRpb24YAiABKA1SCWl0ZXJhdGlvbhIaCghjaGFpbktleRgDIAEoDFIIY2hhaW5LZXkSHgoKc2lnbmluZ0tleRgEIAEoDFIKc2lnbmluZ0tleQ==');
@$core.Deprecated('Use deviceConsistencyCodeMessageDescriptor instead')
const deviceConsistencyCodeMessage$json = {
  '1': 'DeviceConsistencyCodeMessage',
  '2': [
    {'1': 'generation', '3': 1, '4': 1, '5': 13, '10': 'generation'},
    {'1': 'signature', '3': 2, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `DeviceConsistencyCodeMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceConsistencyCodeMessageDescriptor =
    $convert.base64Decode(
        'ChxEZXZpY2VDb25zaXN0ZW5jeUNvZGVNZXNzYWdlEh4KCmdlbmVyYXRpb24YASABKA1SCmdlbmVyYXRpb24SHAoJc2lnbmF0dXJlGAIgASgMUglzaWduYXR1cmU=');

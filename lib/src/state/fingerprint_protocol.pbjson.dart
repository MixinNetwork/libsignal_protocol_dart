import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use logicalFingerprintDescriptor instead')
const logicalFingerprint$json = {
  '1': 'LogicalFingerprint',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `LogicalFingerprint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logicalFingerprintDescriptor =
    $convert.base64Decode(
        'ChJMb2dpY2FsRmluZ2VycHJpbnQSGAoHY29udGVudBgBIAEoDFIHY29udGVudA==');
@$core.Deprecated('Use combinedFingerprintsDescriptor instead')
const sombinedFingerprints$json = {
  '1': 'CombinedFingerprints',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 13, '10': 'version'},
    {
      '1': 'localFingerprint',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.textsecure.LogicalFingerprint',
      '10': 'localFingerprint'
    },
    {
      '1': 'remoteFingerprint',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.textsecure.LogicalFingerprint',
      '10': 'remoteFingerprint'
    },
  ],
};

/// Descriptor for `CombinedFingerprints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List combinedFingerprintsDescriptor = $convert.base64Decode(
    'ChRDb21iaW5lZEZpbmdlcnByaW50cxIYCgd2ZXJzaW9uGAEgASgNUgd2ZXJzaW9uEkoKEGxvY2FsRmluZ2VycHJpbnQYAiABKAsyHi50ZXh0c2VjdXJlLkxvZ2ljYWxGaW5nZXJwcmludFIQbG9jYWxGaW5nZXJwcmludBJMChFyZW1vdGVGaW5nZXJwcmludBgDIAEoCzIeLnRleHRzZWN1cmUuTG9naWNhbEZpbmdlcnByaW50UhFyZW1vdGVGaW5nZXJwcmludA==');

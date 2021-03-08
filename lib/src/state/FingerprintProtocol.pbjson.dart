///
//  Generated code. Do not modify.
//  source: FingerprintProtocol.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use logicalFingerprintDescriptor instead')
const LogicalFingerprint$json = const {
  '1': 'LogicalFingerprint',
  '2': const [
    const {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `LogicalFingerprint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logicalFingerprintDescriptor = $convert.base64Decode('ChJMb2dpY2FsRmluZ2VycHJpbnQSGAoHY29udGVudBgBIAEoDFIHY29udGVudA==');
@$core.Deprecated('Use combinedFingerprintsDescriptor instead')
const CombinedFingerprints$json = const {
  '1': 'CombinedFingerprints',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 13, '10': 'version'},
    const {'1': 'localFingerprint', '3': 2, '4': 1, '5': 11, '6': '.textsecure.LogicalFingerprint', '10': 'localFingerprint'},
    const {'1': 'remoteFingerprint', '3': 3, '4': 1, '5': 11, '6': '.textsecure.LogicalFingerprint', '10': 'remoteFingerprint'},
  ],
};

/// Descriptor for `CombinedFingerprints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List combinedFingerprintsDescriptor = $convert.base64Decode('ChRDb21iaW5lZEZpbmdlcnByaW50cxIYCgd2ZXJzaW9uGAEgASgNUgd2ZXJzaW9uEkoKEGxvY2FsRmluZ2VycHJpbnQYAiABKAsyHi50ZXh0c2VjdXJlLkxvZ2ljYWxGaW5nZXJwcmludFIQbG9jYWxGaW5nZXJwcmludBJMChFyZW1vdGVGaW5nZXJwcmludBgDIAEoCzIeLnRleHRzZWN1cmUuTG9naWNhbEZpbmdlcnByaW50UhFyZW1vdGVGaW5nZXJwcmludA==');

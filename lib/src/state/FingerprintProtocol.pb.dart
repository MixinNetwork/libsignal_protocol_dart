///
//  Generated code. Do not modify.
//  source: FingerprintProtocol.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LogicalFingerprint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LogicalFingerprint', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  LogicalFingerprint._() : super();
  factory LogicalFingerprint() => create();
  factory LogicalFingerprint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LogicalFingerprint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  LogicalFingerprint clone() => LogicalFingerprint()..mergeFromMessage(this);
  LogicalFingerprint copyWith(void Function(LogicalFingerprint) updates) => super.copyWith((message) => updates(message as LogicalFingerprint));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LogicalFingerprint create() => LogicalFingerprint._();
  LogicalFingerprint createEmptyInstance() => create();
  static $pb.PbList<LogicalFingerprint> createRepeated() => $pb.PbList<LogicalFingerprint>();
  @$core.pragma('dart2js:noInline')
  static LogicalFingerprint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogicalFingerprint>(create);
  static LogicalFingerprint _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get content => $_getN(0);
  @$pb.TagNumber(1)
  set content($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
}

class CombinedFingerprints extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CombinedFingerprints', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.int>(1, 'version', $pb.PbFieldType.OU3)
    ..aOM<LogicalFingerprint>(2, 'localFingerprint', protoName: 'localFingerprint', subBuilder: LogicalFingerprint.create)
    ..aOM<LogicalFingerprint>(3, 'remoteFingerprint', protoName: 'remoteFingerprint', subBuilder: LogicalFingerprint.create)
    ..hasRequiredFields = false
  ;

  CombinedFingerprints._() : super();
  factory CombinedFingerprints() => create();
  factory CombinedFingerprints.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CombinedFingerprints.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CombinedFingerprints clone() => CombinedFingerprints()..mergeFromMessage(this);
  CombinedFingerprints copyWith(void Function(CombinedFingerprints) updates) => super.copyWith((message) => updates(message as CombinedFingerprints));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CombinedFingerprints create() => CombinedFingerprints._();
  CombinedFingerprints createEmptyInstance() => create();
  static $pb.PbList<CombinedFingerprints> createRepeated() => $pb.PbList<CombinedFingerprints>();
  @$core.pragma('dart2js:noInline')
  static CombinedFingerprints getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CombinedFingerprints>(create);
  static CombinedFingerprints _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  LogicalFingerprint get localFingerprint => $_getN(1);
  @$pb.TagNumber(2)
  set localFingerprint(LogicalFingerprint v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocalFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalFingerprint() => clearField(2);
  @$pb.TagNumber(2)
  LogicalFingerprint ensureLocalFingerprint() => $_ensure(1);

  @$pb.TagNumber(3)
  LogicalFingerprint get remoteFingerprint => $_getN(2);
  @$pb.TagNumber(3)
  set remoteFingerprint(LogicalFingerprint v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRemoteFingerprint() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoteFingerprint() => clearField(3);
  @$pb.TagNumber(3)
  LogicalFingerprint ensureRemoteFingerprint() => $_ensure(2);
}


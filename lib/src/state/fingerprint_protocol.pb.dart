import 'dart:core' as $core;
import 'dart:core';

import 'package:protobuf/protobuf.dart' as $pb;

class LogicalFingerprint extends $pb.GeneratedMessage {
  factory LogicalFingerprint({
    $core.List<$core.int>? content,
  }) {
    final _result = create();
    if (content != null) {
      _result.content = content;
    }
    return _result;
  }

  LogicalFingerprint._() : super();

  factory LogicalFingerprint.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory LogicalFingerprint.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'LogicalFingerprint',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  LogicalFingerprint clone() => LogicalFingerprint()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  LogicalFingerprint copyWith(void Function(LogicalFingerprint) updates) =>
      super.copyWith((message) => updates(message as LogicalFingerprint))
          as LogicalFingerprint; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogicalFingerprint create() => LogicalFingerprint._();

  @override
  LogicalFingerprint createEmptyInstance() => create();

  static $pb.PbList<LogicalFingerprint> createRepeated() =>
      $pb.PbList<LogicalFingerprint>();

  @$core.pragma('dart2js:noInline')
  static LogicalFingerprint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogicalFingerprint>(create);
  static LogicalFingerprint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get content => $_getN(0);

  @$pb.TagNumber(1)
  set content($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);

  @$pb.TagNumber(1)
  void clearContent() => clearField(1);
}

class CombinedFingerprints extends $pb.GeneratedMessage {
  factory CombinedFingerprints({
    $core.int? version,
    LogicalFingerprint? localFingerprint,
    LogicalFingerprint? remoteFingerprint,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    if (localFingerprint != null) {
      _result.localFingerprint = localFingerprint;
    }
    if (remoteFingerprint != null) {
      _result.remoteFingerprint = remoteFingerprint;
    }
    return _result;
  }

  CombinedFingerprints._() : super();

  factory CombinedFingerprints.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory CombinedFingerprints.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CombinedFingerprints',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version',
        $pb.PbFieldType.OU3)
    ..aOM<LogicalFingerprint>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'localFingerprint',
        protoName: 'localFingerprint',
        subBuilder: LogicalFingerprint.create)
    ..aOM<LogicalFingerprint>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'remoteFingerprint',
        protoName: 'remoteFingerprint',
        subBuilder: LogicalFingerprint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  CombinedFingerprints clone() =>
      CombinedFingerprints()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  CombinedFingerprints copyWith(void Function(CombinedFingerprints) updates) =>
      super.copyWith((message) => updates(message as CombinedFingerprints))
          as CombinedFingerprints; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CombinedFingerprints create() => CombinedFingerprints._();

  @override
  CombinedFingerprints createEmptyInstance() => create();

  static $pb.PbList<CombinedFingerprints> createRepeated() =>
      $pb.PbList<CombinedFingerprints>();

  @$core.pragma('dart2js:noInline')
  static CombinedFingerprints getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CombinedFingerprints>(create);
  static CombinedFingerprints? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);

  @$pb.TagNumber(1)
  set version($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);

  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  LogicalFingerprint get localFingerprint => $_getN(1);

  @$pb.TagNumber(2)
  set localFingerprint(LogicalFingerprint v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLocalFingerprint() => $_has(1);

  @$pb.TagNumber(2)
  void clearLocalFingerprint() => clearField(2);

  @$pb.TagNumber(2)
  LogicalFingerprint ensureLocalFingerprint() => $_ensure(1);

  @$pb.TagNumber(3)
  LogicalFingerprint get remoteFingerprint => $_getN(2);

  @$pb.TagNumber(3)
  set remoteFingerprint(LogicalFingerprint v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRemoteFingerprint() => $_has(2);

  @$pb.TagNumber(3)
  void clearRemoteFingerprint() => clearField(3);

  @$pb.TagNumber(3)
  LogicalFingerprint ensureRemoteFingerprint() => $_ensure(2);
}

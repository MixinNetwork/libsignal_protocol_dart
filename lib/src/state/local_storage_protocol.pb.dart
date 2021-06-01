///
//  Generated code. Do not modify.
//  source: LocalStorageProtocol.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class SessionStructure_Chain_ChainKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SessionStructure.Chain.ChainKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'index',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SessionStructure_Chain_ChainKey._() : super();
  factory SessionStructure_Chain_ChainKey({
    $core.int? index,
    $core.List<$core.int>? key,
  }) {
    final _result = create();
    if (index != null) {
      _result.index = index;
    }
    if (key != null) {
      _result.key = key;
    }
    return _result;
  }
  factory SessionStructure_Chain_ChainKey.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SessionStructure_Chain_ChainKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SessionStructure_Chain_ChainKey clone() =>
      SessionStructure_Chain_ChainKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SessionStructure_Chain_ChainKey copyWith(
          void Function(SessionStructure_Chain_ChainKey) updates) =>
      super.copyWith(
              (message) => updates(message as SessionStructure_Chain_ChainKey))
          as SessionStructure_Chain_ChainKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionStructure_Chain_ChainKey create() =>
      SessionStructure_Chain_ChainKey._();
  SessionStructure_Chain_ChainKey createEmptyInstance() => create();
  static $pb.PbList<SessionStructure_Chain_ChainKey> createRepeated() =>
      $pb.PbList<SessionStructure_Chain_ChainKey>();
  @$core.pragma('dart2js:noInline')
  static SessionStructure_Chain_ChainKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionStructure_Chain_ChainKey>(
          create);
  static SessionStructure_Chain_ChainKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get key => $_getN(1);
  @$pb.TagNumber(2)
  set key($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);
}

class SessionStructure_Chain_MessageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SessionStructure.Chain.MessageKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'index',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cipherKey', $pb.PbFieldType.OY,
        protoName: 'cipherKey')
    ..a<$core.List<$core.int>>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'macKey', $pb.PbFieldType.OY,
        protoName: 'macKey')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iv', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SessionStructure_Chain_MessageKey._() : super();
  factory SessionStructure_Chain_MessageKey({
    $core.int? index,
    $core.List<$core.int>? cipherKey,
    $core.List<$core.int>? macKey,
    $core.List<$core.int>? iv,
  }) {
    final _result = create();
    if (index != null) {
      _result.index = index;
    }
    if (cipherKey != null) {
      _result.cipherKey = cipherKey;
    }
    if (macKey != null) {
      _result.macKey = macKey;
    }
    if (iv != null) {
      _result.iv = iv;
    }
    return _result;
  }
  factory SessionStructure_Chain_MessageKey.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SessionStructure_Chain_MessageKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SessionStructure_Chain_MessageKey clone() =>
      SessionStructure_Chain_MessageKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SessionStructure_Chain_MessageKey copyWith(
          void Function(SessionStructure_Chain_MessageKey) updates) =>
      super.copyWith((message) =>
              updates(message as SessionStructure_Chain_MessageKey))
          as SessionStructure_Chain_MessageKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionStructure_Chain_MessageKey create() =>
      SessionStructure_Chain_MessageKey._();
  SessionStructure_Chain_MessageKey createEmptyInstance() => create();
  static $pb.PbList<SessionStructure_Chain_MessageKey> createRepeated() =>
      $pb.PbList<SessionStructure_Chain_MessageKey>();
  @$core.pragma('dart2js:noInline')
  static SessionStructure_Chain_MessageKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionStructure_Chain_MessageKey>(
          create);
  static SessionStructure_Chain_MessageKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cipherKey => $_getN(1);
  @$pb.TagNumber(2)
  set cipherKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCipherKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCipherKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get macKey => $_getN(2);
  @$pb.TagNumber(3)
  set macKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMacKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearMacKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get iv => $_getN(3);
  @$pb.TagNumber(4)
  set iv($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasIv() => $_has(3);
  @$pb.TagNumber(4)
  void clearIv() => clearField(4);
}

class SessionStructure_Chain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SessionStructure.Chain',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderRatchetKey', $pb.PbFieldType.OY,
        protoName: 'senderRatchetKey')
    ..a<$core.List<$core.int>>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderRatchetKeyPrivate', $pb.PbFieldType.OY,
        protoName: 'senderRatchetKeyPrivate')
    ..aOM<SessionStructure_Chain_ChainKey>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainKey',
        protoName: 'chainKey',
        subBuilder: SessionStructure_Chain_ChainKey.create)
    ..pc<SessionStructure_Chain_MessageKey>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'messageKeys', $pb.PbFieldType.PM,
        protoName: 'messageKeys',
        subBuilder: SessionStructure_Chain_MessageKey.create)
    ..hasRequiredFields = false;

  SessionStructure_Chain._() : super();
  factory SessionStructure_Chain({
    $core.List<$core.int>? senderRatchetKey,
    $core.List<$core.int>? senderRatchetKeyPrivate,
    SessionStructure_Chain_ChainKey? chainKey,
    $core.Iterable<SessionStructure_Chain_MessageKey>? messageKeys,
  }) {
    final _result = create();
    if (senderRatchetKey != null) {
      _result.senderRatchetKey = senderRatchetKey;
    }
    if (senderRatchetKeyPrivate != null) {
      _result.senderRatchetKeyPrivate = senderRatchetKeyPrivate;
    }
    if (chainKey != null) {
      _result.chainKey = chainKey;
    }
    if (messageKeys != null) {
      _result.messageKeys.addAll(messageKeys);
    }
    return _result;
  }
  factory SessionStructure_Chain.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SessionStructure_Chain.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SessionStructure_Chain clone() =>
      SessionStructure_Chain()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SessionStructure_Chain copyWith(
          void Function(SessionStructure_Chain) updates) =>
      super.copyWith((message) => updates(message as SessionStructure_Chain))
          as SessionStructure_Chain; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionStructure_Chain create() => SessionStructure_Chain._();
  SessionStructure_Chain createEmptyInstance() => create();
  static $pb.PbList<SessionStructure_Chain> createRepeated() =>
      $pb.PbList<SessionStructure_Chain>();
  @$core.pragma('dart2js:noInline')
  static SessionStructure_Chain getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionStructure_Chain>(create);
  static SessionStructure_Chain? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get senderRatchetKey => $_getN(0);
  @$pb.TagNumber(1)
  set senderRatchetKey($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSenderRatchetKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderRatchetKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get senderRatchetKeyPrivate => $_getN(1);
  @$pb.TagNumber(2)
  set senderRatchetKeyPrivate($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSenderRatchetKeyPrivate() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderRatchetKeyPrivate() => clearField(2);

  @$pb.TagNumber(3)
  SessionStructure_Chain_ChainKey get chainKey => $_getN(2);
  @$pb.TagNumber(3)
  set chainKey(SessionStructure_Chain_ChainKey v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasChainKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearChainKey() => clearField(3);
  @$pb.TagNumber(3)
  SessionStructure_Chain_ChainKey ensureChainKey() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<SessionStructure_Chain_MessageKey> get messageKeys => $_getList(3);
}

class SessionStructure_PendingKeyExchange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SessionStructure.PendingKeyExchange',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sequence',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localBaseKey', $pb.PbFieldType.OY,
        protoName: 'localBaseKey')
    ..a<$core.List<$core.int>>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localBaseKeyPrivate', $pb.PbFieldType.OY,
        protoName: 'localBaseKeyPrivate')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localRatchetKey', $pb.PbFieldType.OY, protoName: 'localRatchetKey')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localRatchetKeyPrivate', $pb.PbFieldType.OY, protoName: 'localRatchetKeyPrivate')
    ..a<$core.List<$core.int>>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localIdentityKey', $pb.PbFieldType.OY, protoName: 'localIdentityKey')
    ..a<$core.List<$core.int>>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localIdentityKeyPrivate', $pb.PbFieldType.OY, protoName: 'localIdentityKeyPrivate')
    ..hasRequiredFields = false;

  SessionStructure_PendingKeyExchange._() : super();
  factory SessionStructure_PendingKeyExchange({
    $core.int? sequence,
    $core.List<$core.int>? localBaseKey,
    $core.List<$core.int>? localBaseKeyPrivate,
    $core.List<$core.int>? localRatchetKey,
    $core.List<$core.int>? localRatchetKeyPrivate,
    $core.List<$core.int>? localIdentityKey,
    $core.List<$core.int>? localIdentityKeyPrivate,
  }) {
    final _result = create();
    if (sequence != null) {
      _result.sequence = sequence;
    }
    if (localBaseKey != null) {
      _result.localBaseKey = localBaseKey;
    }
    if (localBaseKeyPrivate != null) {
      _result.localBaseKeyPrivate = localBaseKeyPrivate;
    }
    if (localRatchetKey != null) {
      _result.localRatchetKey = localRatchetKey;
    }
    if (localRatchetKeyPrivate != null) {
      _result.localRatchetKeyPrivate = localRatchetKeyPrivate;
    }
    if (localIdentityKey != null) {
      _result.localIdentityKey = localIdentityKey;
    }
    if (localIdentityKeyPrivate != null) {
      _result.localIdentityKeyPrivate = localIdentityKeyPrivate;
    }
    return _result;
  }
  factory SessionStructure_PendingKeyExchange.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SessionStructure_PendingKeyExchange.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SessionStructure_PendingKeyExchange clone() =>
      SessionStructure_PendingKeyExchange()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SessionStructure_PendingKeyExchange copyWith(
          void Function(SessionStructure_PendingKeyExchange) updates) =>
      super.copyWith((message) =>
              updates(message as SessionStructure_PendingKeyExchange))
          as SessionStructure_PendingKeyExchange; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionStructure_PendingKeyExchange create() =>
      SessionStructure_PendingKeyExchange._();
  SessionStructure_PendingKeyExchange createEmptyInstance() => create();
  static $pb.PbList<SessionStructure_PendingKeyExchange> createRepeated() =>
      $pb.PbList<SessionStructure_PendingKeyExchange>();
  @$core.pragma('dart2js:noInline')
  static SessionStructure_PendingKeyExchange getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SessionStructure_PendingKeyExchange>(create);
  static SessionStructure_PendingKeyExchange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set sequence($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get localBaseKey => $_getN(1);
  @$pb.TagNumber(2)
  set localBaseKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLocalBaseKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get localBaseKeyPrivate => $_getN(2);
  @$pb.TagNumber(3)
  set localBaseKeyPrivate($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLocalBaseKeyPrivate() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocalBaseKeyPrivate() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get localRatchetKey => $_getN(3);
  @$pb.TagNumber(4)
  set localRatchetKey($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasLocalRatchetKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocalRatchetKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get localRatchetKeyPrivate => $_getN(4);
  @$pb.TagNumber(5)
  set localRatchetKeyPrivate($core.List<$core.int> v) {
    $_setBytes(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasLocalRatchetKeyPrivate() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocalRatchetKeyPrivate() => clearField(5);

  @$pb.TagNumber(7)
  $core.List<$core.int> get localIdentityKey => $_getN(5);
  @$pb.TagNumber(7)
  set localIdentityKey($core.List<$core.int> v) {
    $_setBytes(5, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLocalIdentityKey() => $_has(5);
  @$pb.TagNumber(7)
  void clearLocalIdentityKey() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get localIdentityKeyPrivate => $_getN(6);
  @$pb.TagNumber(8)
  set localIdentityKeyPrivate($core.List<$core.int> v) {
    $_setBytes(6, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasLocalIdentityKeyPrivate() => $_has(6);
  @$pb.TagNumber(8)
  void clearLocalIdentityKeyPrivate() => clearField(8);
}

class SessionStructure_PendingPreKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SessionStructure.PendingPreKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preKeyId', $pb.PbFieldType.OU3,
        protoName: 'preKeyId')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'baseKey',
        $pb.PbFieldType.OY,
        protoName: 'baseKey')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signedPreKeyId', $pb.PbFieldType.O3, protoName: 'signedPreKeyId')
    ..hasRequiredFields = false;

  SessionStructure_PendingPreKey._() : super();
  factory SessionStructure_PendingPreKey({
    $core.int? preKeyId,
    $core.List<$core.int>? baseKey,
    $core.int? signedPreKeyId,
  }) {
    final _result = create();
    if (preKeyId != null) {
      _result.preKeyId = preKeyId;
    }
    if (baseKey != null) {
      _result.baseKey = baseKey;
    }
    if (signedPreKeyId != null) {
      _result.signedPreKeyId = signedPreKeyId;
    }
    return _result;
  }
  factory SessionStructure_PendingPreKey.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SessionStructure_PendingPreKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SessionStructure_PendingPreKey clone() =>
      SessionStructure_PendingPreKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SessionStructure_PendingPreKey copyWith(
          void Function(SessionStructure_PendingPreKey) updates) =>
      super.copyWith(
              (message) => updates(message as SessionStructure_PendingPreKey))
          as SessionStructure_PendingPreKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionStructure_PendingPreKey create() =>
      SessionStructure_PendingPreKey._();
  SessionStructure_PendingPreKey createEmptyInstance() => create();
  static $pb.PbList<SessionStructure_PendingPreKey> createRepeated() =>
      $pb.PbList<SessionStructure_PendingPreKey>();
  @$core.pragma('dart2js:noInline')
  static SessionStructure_PendingPreKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionStructure_PendingPreKey>(create);
  static SessionStructure_PendingPreKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set preKeyId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get baseKey => $_getN(1);
  @$pb.TagNumber(2)
  set baseKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBaseKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get signedPreKeyId => $_getIZ(2);
  @$pb.TagNumber(3)
  set signedPreKeyId($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSignedPreKeyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignedPreKeyId() => clearField(3);
}

class SessionStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SessionStructure',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionVersion', $pb.PbFieldType.OU3,
        protoName: 'sessionVersion')
    ..a<$core.List<$core.int>>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localIdentityPublic', $pb.PbFieldType.OY,
        protoName: 'localIdentityPublic')
    ..a<$core.List<$core.int>>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remoteIdentityPublic', $pb.PbFieldType.OY,
        protoName: 'remoteIdentityPublic')
    ..a<$core.List<$core.int>>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rootKey', $pb.PbFieldType.OY,
        protoName: 'rootKey')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previousCounter', $pb.PbFieldType.OU3, protoName: 'previousCounter')
    ..aOM<SessionStructure_Chain>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderChain', protoName: 'senderChain', subBuilder: SessionStructure_Chain.create)
    ..pc<SessionStructure_Chain>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiverChains', $pb.PbFieldType.PM, protoName: 'receiverChains', subBuilder: SessionStructure_Chain.create)
    ..aOM<SessionStructure_PendingKeyExchange>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingKeyExchange', protoName: 'pendingKeyExchange', subBuilder: SessionStructure_PendingKeyExchange.create)
    ..aOM<SessionStructure_PendingPreKey>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingPreKey', protoName: 'pendingPreKey', subBuilder: SessionStructure_PendingPreKey.create)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remoteRegistrationId', $pb.PbFieldType.OU3, protoName: 'remoteRegistrationId')
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localRegistrationId', $pb.PbFieldType.OU3, protoName: 'localRegistrationId')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'needsRefresh', protoName: 'needsRefresh')
    ..a<$core.List<$core.int>>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'aliceBaseKey', $pb.PbFieldType.OY, protoName: 'aliceBaseKey')
    ..hasRequiredFields = false;

  SessionStructure._() : super();
  factory SessionStructure({
    $core.int? sessionVersion,
    $core.List<$core.int>? localIdentityPublic,
    $core.List<$core.int>? remoteIdentityPublic,
    $core.List<$core.int>? rootKey,
    $core.int? previousCounter,
    SessionStructure_Chain? senderChain,
    $core.Iterable<SessionStructure_Chain>? receiverChains,
    SessionStructure_PendingKeyExchange? pendingKeyExchange,
    SessionStructure_PendingPreKey? pendingPreKey,
    $core.int? remoteRegistrationId,
    $core.int? localRegistrationId,
    $core.bool? needsRefresh,
    $core.List<$core.int>? aliceBaseKey,
  }) {
    final _result = create();
    if (sessionVersion != null) {
      _result.sessionVersion = sessionVersion;
    }
    if (localIdentityPublic != null) {
      _result.localIdentityPublic = localIdentityPublic;
    }
    if (remoteIdentityPublic != null) {
      _result.remoteIdentityPublic = remoteIdentityPublic;
    }
    if (rootKey != null) {
      _result.rootKey = rootKey;
    }
    if (previousCounter != null) {
      _result.previousCounter = previousCounter;
    }
    if (senderChain != null) {
      _result.senderChain = senderChain;
    }
    if (receiverChains != null) {
      _result.receiverChains.addAll(receiverChains);
    }
    if (pendingKeyExchange != null) {
      _result.pendingKeyExchange = pendingKeyExchange;
    }
    if (pendingPreKey != null) {
      _result.pendingPreKey = pendingPreKey;
    }
    if (remoteRegistrationId != null) {
      _result.remoteRegistrationId = remoteRegistrationId;
    }
    if (localRegistrationId != null) {
      _result.localRegistrationId = localRegistrationId;
    }
    if (needsRefresh != null) {
      _result.needsRefresh = needsRefresh;
    }
    if (aliceBaseKey != null) {
      _result.aliceBaseKey = aliceBaseKey;
    }
    return _result;
  }
  factory SessionStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SessionStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SessionStructure clone() => SessionStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SessionStructure copyWith(void Function(SessionStructure) updates) =>
      super.copyWith((message) => updates(message as SessionStructure))
          as SessionStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SessionStructure create() => SessionStructure._();
  SessionStructure createEmptyInstance() => create();
  static $pb.PbList<SessionStructure> createRepeated() =>
      $pb.PbList<SessionStructure>();
  @$core.pragma('dart2js:noInline')
  static SessionStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionStructure>(create);
  static SessionStructure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sessionVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set sessionVersion($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSessionVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get localIdentityPublic => $_getN(1);
  @$pb.TagNumber(2)
  set localIdentityPublic($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLocalIdentityPublic() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalIdentityPublic() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get remoteIdentityPublic => $_getN(2);
  @$pb.TagNumber(3)
  set remoteIdentityPublic($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRemoteIdentityPublic() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoteIdentityPublic() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get rootKey => $_getN(3);
  @$pb.TagNumber(4)
  set rootKey($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRootKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearRootKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get previousCounter => $_getIZ(4);
  @$pb.TagNumber(5)
  set previousCounter($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPreviousCounter() => $_has(4);
  @$pb.TagNumber(5)
  void clearPreviousCounter() => clearField(5);

  @$pb.TagNumber(6)
  SessionStructure_Chain get senderChain => $_getN(5);
  @$pb.TagNumber(6)
  set senderChain(SessionStructure_Chain v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSenderChain() => $_has(5);
  @$pb.TagNumber(6)
  void clearSenderChain() => clearField(6);
  @$pb.TagNumber(6)
  SessionStructure_Chain ensureSenderChain() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.List<SessionStructure_Chain> get receiverChains => $_getList(6);

  @$pb.TagNumber(8)
  SessionStructure_PendingKeyExchange get pendingKeyExchange => $_getN(7);
  @$pb.TagNumber(8)
  set pendingKeyExchange(SessionStructure_PendingKeyExchange v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPendingKeyExchange() => $_has(7);
  @$pb.TagNumber(8)
  void clearPendingKeyExchange() => clearField(8);
  @$pb.TagNumber(8)
  SessionStructure_PendingKeyExchange ensurePendingKeyExchange() => $_ensure(7);

  @$pb.TagNumber(9)
  SessionStructure_PendingPreKey get pendingPreKey => $_getN(8);
  @$pb.TagNumber(9)
  set pendingPreKey(SessionStructure_PendingPreKey v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPendingPreKey() => $_has(8);
  @$pb.TagNumber(9)
  void clearPendingPreKey() => clearField(9);
  @$pb.TagNumber(9)
  SessionStructure_PendingPreKey ensurePendingPreKey() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get remoteRegistrationId => $_getIZ(9);
  @$pb.TagNumber(10)
  set remoteRegistrationId($core.int v) {
    $_setUnsignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasRemoteRegistrationId() => $_has(9);
  @$pb.TagNumber(10)
  void clearRemoteRegistrationId() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get localRegistrationId => $_getIZ(10);
  @$pb.TagNumber(11)
  set localRegistrationId($core.int v) {
    $_setUnsignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasLocalRegistrationId() => $_has(10);
  @$pb.TagNumber(11)
  void clearLocalRegistrationId() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get needsRefresh => $_getBF(11);
  @$pb.TagNumber(12)
  set needsRefresh($core.bool v) {
    $_setBool(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasNeedsRefresh() => $_has(11);
  @$pb.TagNumber(12)
  void clearNeedsRefresh() => clearField(12);

  @$pb.TagNumber(13)
  $core.List<$core.int> get aliceBaseKey => $_getN(12);
  @$pb.TagNumber(13)
  set aliceBaseKey($core.List<$core.int> v) {
    $_setBytes(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasAliceBaseKey() => $_has(12);
  @$pb.TagNumber(13)
  void clearAliceBaseKey() => clearField(13);
}

class RecordStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'RecordStructure',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..aOM<SessionStructure>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentSession',
        protoName: 'currentSession', subBuilder: SessionStructure.create)
    ..pc<SessionStructure>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'previousSessions',
        $pb.PbFieldType.PM,
        protoName: 'previousSessions',
        subBuilder: SessionStructure.create)
    ..hasRequiredFields = false;

  RecordStructure._() : super();
  factory RecordStructure({
    SessionStructure? currentSession,
    $core.Iterable<SessionStructure>? previousSessions,
  }) {
    final _result = create();
    if (currentSession != null) {
      _result.currentSession = currentSession;
    }
    if (previousSessions != null) {
      _result.previousSessions.addAll(previousSessions);
    }
    return _result;
  }
  factory RecordStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RecordStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  RecordStructure clone() => RecordStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  RecordStructure copyWith(void Function(RecordStructure) updates) =>
      super.copyWith((message) => updates(message as RecordStructure))
          as RecordStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecordStructure create() => RecordStructure._();
  RecordStructure createEmptyInstance() => create();
  static $pb.PbList<RecordStructure> createRepeated() =>
      $pb.PbList<RecordStructure>();
  @$core.pragma('dart2js:noInline')
  static RecordStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordStructure>(create);
  static RecordStructure? _defaultInstance;

  @$pb.TagNumber(1)
  SessionStructure get currentSession => $_getN(0);
  @$pb.TagNumber(1)
  set currentSession(SessionStructure v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCurrentSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentSession() => clearField(1);
  @$pb.TagNumber(1)
  SessionStructure ensureCurrentSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<SessionStructure> get previousSessions => $_getList(1);
}

class PreKeyRecordStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PreKeyRecordStructure',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', $pb.PbFieldType.OY,
        protoName: 'publicKey')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'privateKey',
        $pb.PbFieldType.OY,
        protoName: 'privateKey')
    ..hasRequiredFields = false;

  PreKeyRecordStructure._() : super();
  factory PreKeyRecordStructure({
    $core.int? id,
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? privateKey,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (privateKey != null) {
      _result.privateKey = privateKey;
    }
    return _result;
  }
  factory PreKeyRecordStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PreKeyRecordStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PreKeyRecordStructure clone() =>
      PreKeyRecordStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PreKeyRecordStructure copyWith(
          void Function(PreKeyRecordStructure) updates) =>
      super.copyWith((message) => updates(message as PreKeyRecordStructure))
          as PreKeyRecordStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PreKeyRecordStructure create() => PreKeyRecordStructure._();
  PreKeyRecordStructure createEmptyInstance() => create();
  static $pb.PbList<PreKeyRecordStructure> createRepeated() =>
      $pb.PbList<PreKeyRecordStructure>();
  @$core.pragma('dart2js:noInline')
  static PreKeyRecordStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreKeyRecordStructure>(create);
  static PreKeyRecordStructure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get privateKey => $_getN(2);
  @$pb.TagNumber(3)
  set privateKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivateKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivateKey() => clearField(3);
}

class SignedPreKeyRecordStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SignedPreKeyRecordStructure',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', $pb.PbFieldType.OY,
        protoName: 'publicKey')
    ..a<$core.List<$core.int>>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'privateKey', $pb.PbFieldType.OY,
        protoName: 'privateKey')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signature', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp', $pb.PbFieldType.OF6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  SignedPreKeyRecordStructure._() : super();
  factory SignedPreKeyRecordStructure({
    $core.int? id,
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? privateKey,
    $core.List<$core.int>? signature,
    $fixnum.Int64? timestamp,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (privateKey != null) {
      _result.privateKey = privateKey;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory SignedPreKeyRecordStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SignedPreKeyRecordStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SignedPreKeyRecordStructure clone() =>
      SignedPreKeyRecordStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SignedPreKeyRecordStructure copyWith(
          void Function(SignedPreKeyRecordStructure) updates) =>
      super.copyWith(
              (message) => updates(message as SignedPreKeyRecordStructure))
          as SignedPreKeyRecordStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignedPreKeyRecordStructure create() =>
      SignedPreKeyRecordStructure._();
  SignedPreKeyRecordStructure createEmptyInstance() => create();
  static $pb.PbList<SignedPreKeyRecordStructure> createRepeated() =>
      $pb.PbList<SignedPreKeyRecordStructure>();
  @$core.pragma('dart2js:noInline')
  static SignedPreKeyRecordStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignedPreKeyRecordStructure>(create);
  static SignedPreKeyRecordStructure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get privateKey => $_getN(2);
  @$pb.TagNumber(3)
  set privateKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivateKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrivateKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get signature => $_getN(3);
  @$pb.TagNumber(4)
  set signature($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignature() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);
}

class IdentityKeyPairStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'IdentityKeyPairStructure',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', $pb.PbFieldType.OY,
        protoName: 'publicKey')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'privateKey',
        $pb.PbFieldType.OY,
        protoName: 'privateKey')
    ..hasRequiredFields = false;

  IdentityKeyPairStructure._() : super();
  factory IdentityKeyPairStructure({
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? privateKey,
  }) {
    final _result = create();
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (privateKey != null) {
      _result.privateKey = privateKey;
    }
    return _result;
  }
  factory IdentityKeyPairStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IdentityKeyPairStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  IdentityKeyPairStructure clone() =>
      IdentityKeyPairStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  IdentityKeyPairStructure copyWith(
          void Function(IdentityKeyPairStructure) updates) =>
      super.copyWith((message) => updates(message as IdentityKeyPairStructure))
          as IdentityKeyPairStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IdentityKeyPairStructure create() => IdentityKeyPairStructure._();
  IdentityKeyPairStructure createEmptyInstance() => create();
  static $pb.PbList<IdentityKeyPairStructure> createRepeated() =>
      $pb.PbList<IdentityKeyPairStructure>();
  @$core.pragma('dart2js:noInline')
  static IdentityKeyPairStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentityKeyPairStructure>(create);
  static IdentityKeyPairStructure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get privateKey => $_getN(1);
  @$pb.TagNumber(2)
  set privateKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPrivateKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrivateKey() => clearField(2);
}

class SenderKeyStateStructure_SenderChainKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SenderKeyStateStructure.SenderChainKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'iteration',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seed',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SenderKeyStateStructure_SenderChainKey._() : super();
  factory SenderKeyStateStructure_SenderChainKey({
    $core.int? iteration,
    $core.List<$core.int>? seed,
  }) {
    final _result = create();
    if (iteration != null) {
      _result.iteration = iteration;
    }
    if (seed != null) {
      _result.seed = seed;
    }
    return _result;
  }
  factory SenderKeyStateStructure_SenderChainKey.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SenderKeyStateStructure_SenderChainKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure_SenderChainKey clone() =>
      SenderKeyStateStructure_SenderChainKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure_SenderChainKey copyWith(
          void Function(SenderKeyStateStructure_SenderChainKey) updates) =>
      super.copyWith((message) =>
              updates(message as SenderKeyStateStructure_SenderChainKey))
          as SenderKeyStateStructure_SenderChainKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure_SenderChainKey create() =>
      SenderKeyStateStructure_SenderChainKey._();
  SenderKeyStateStructure_SenderChainKey createEmptyInstance() => create();
  static $pb.PbList<SenderKeyStateStructure_SenderChainKey> createRepeated() =>
      $pb.PbList<SenderKeyStateStructure_SenderChainKey>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure_SenderChainKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SenderKeyStateStructure_SenderChainKey>(create);
  static SenderKeyStateStructure_SenderChainKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get iteration => $_getIZ(0);
  @$pb.TagNumber(1)
  set iteration($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIteration() => $_has(0);
  @$pb.TagNumber(1)
  void clearIteration() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get seed => $_getN(1);
  @$pb.TagNumber(2)
  set seed($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSeed() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeed() => clearField(2);
}

class SenderKeyStateStructure_SenderMessageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SenderKeyStateStructure.SenderMessageKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'iteration',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seed',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SenderKeyStateStructure_SenderMessageKey._() : super();
  factory SenderKeyStateStructure_SenderMessageKey({
    $core.int? iteration,
    $core.List<$core.int>? seed,
  }) {
    final _result = create();
    if (iteration != null) {
      _result.iteration = iteration;
    }
    if (seed != null) {
      _result.seed = seed;
    }
    return _result;
  }
  factory SenderKeyStateStructure_SenderMessageKey.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SenderKeyStateStructure_SenderMessageKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure_SenderMessageKey clone() =>
      SenderKeyStateStructure_SenderMessageKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure_SenderMessageKey copyWith(
          void Function(SenderKeyStateStructure_SenderMessageKey) updates) =>
      super.copyWith((message) =>
              updates(message as SenderKeyStateStructure_SenderMessageKey))
          as SenderKeyStateStructure_SenderMessageKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure_SenderMessageKey create() =>
      SenderKeyStateStructure_SenderMessageKey._();
  SenderKeyStateStructure_SenderMessageKey createEmptyInstance() => create();
  static $pb.PbList<SenderKeyStateStructure_SenderMessageKey>
      createRepeated() =>
          $pb.PbList<SenderKeyStateStructure_SenderMessageKey>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure_SenderMessageKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SenderKeyStateStructure_SenderMessageKey>(create);
  static SenderKeyStateStructure_SenderMessageKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get iteration => $_getIZ(0);
  @$pb.TagNumber(1)
  set iteration($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIteration() => $_has(0);
  @$pb.TagNumber(1)
  void clearIteration() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get seed => $_getN(1);
  @$pb.TagNumber(2)
  set seed($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSeed() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeed() => clearField(2);
}

class SenderKeyStateStructure_SenderSigningKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SenderKeyStateStructure.SenderSigningKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'public',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'private',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SenderKeyStateStructure_SenderSigningKey._() : super();
  factory SenderKeyStateStructure_SenderSigningKey({
    $core.List<$core.int>? public,
    $core.List<$core.int>? private,
  }) {
    final _result = create();
    if (public != null) {
      _result.public = public;
    }
    if (private != null) {
      _result.private = private;
    }
    return _result;
  }
  factory SenderKeyStateStructure_SenderSigningKey.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SenderKeyStateStructure_SenderSigningKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure_SenderSigningKey clone() =>
      SenderKeyStateStructure_SenderSigningKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure_SenderSigningKey copyWith(
          void Function(SenderKeyStateStructure_SenderSigningKey) updates) =>
      super.copyWith((message) =>
              updates(message as SenderKeyStateStructure_SenderSigningKey))
          as SenderKeyStateStructure_SenderSigningKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure_SenderSigningKey create() =>
      SenderKeyStateStructure_SenderSigningKey._();
  SenderKeyStateStructure_SenderSigningKey createEmptyInstance() => create();
  static $pb.PbList<SenderKeyStateStructure_SenderSigningKey>
      createRepeated() =>
          $pb.PbList<SenderKeyStateStructure_SenderSigningKey>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure_SenderSigningKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SenderKeyStateStructure_SenderSigningKey>(create);
  static SenderKeyStateStructure_SenderSigningKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get public => $_getN(0);
  @$pb.TagNumber(1)
  set public($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPublic() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublic() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get private => $_getN(1);
  @$pb.TagNumber(2)
  set private($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPrivate() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrivate() => clearField(2);
}

class SenderKeyStateStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SenderKeyStateStructure',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderKeyId', $pb.PbFieldType.OU3,
        protoName: 'senderKeyId')
    ..aOM<SenderKeyStateStructure_SenderChainKey>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderChainKey',
        protoName: 'senderChainKey',
        subBuilder: SenderKeyStateStructure_SenderChainKey.create)
    ..aOM<SenderKeyStateStructure_SenderSigningKey>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderSigningKey',
        protoName: 'senderSigningKey',
        subBuilder: SenderKeyStateStructure_SenderSigningKey.create)
    ..pc<SenderKeyStateStructure_SenderMessageKey>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderMessageKeys', $pb.PbFieldType.PM,
        protoName: 'senderMessageKeys',
        subBuilder: SenderKeyStateStructure_SenderMessageKey.create)
    ..hasRequiredFields = false;

  SenderKeyStateStructure._() : super();
  factory SenderKeyStateStructure({
    $core.int? senderKeyId,
    SenderKeyStateStructure_SenderChainKey? senderChainKey,
    SenderKeyStateStructure_SenderSigningKey? senderSigningKey,
    $core.Iterable<SenderKeyStateStructure_SenderMessageKey>? senderMessageKeys,
  }) {
    final _result = create();
    if (senderKeyId != null) {
      _result.senderKeyId = senderKeyId;
    }
    if (senderChainKey != null) {
      _result.senderChainKey = senderChainKey;
    }
    if (senderSigningKey != null) {
      _result.senderSigningKey = senderSigningKey;
    }
    if (senderMessageKeys != null) {
      _result.senderMessageKeys.addAll(senderMessageKeys);
    }
    return _result;
  }
  factory SenderKeyStateStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SenderKeyStateStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure clone() =>
      SenderKeyStateStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SenderKeyStateStructure copyWith(
          void Function(SenderKeyStateStructure) updates) =>
      super.copyWith((message) => updates(message as SenderKeyStateStructure))
          as SenderKeyStateStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure create() => SenderKeyStateStructure._();
  SenderKeyStateStructure createEmptyInstance() => create();
  static $pb.PbList<SenderKeyStateStructure> createRepeated() =>
      $pb.PbList<SenderKeyStateStructure>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyStateStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SenderKeyStateStructure>(create);
  static SenderKeyStateStructure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get senderKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set senderKeyId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSenderKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderKeyId() => clearField(1);

  @$pb.TagNumber(2)
  SenderKeyStateStructure_SenderChainKey get senderChainKey => $_getN(1);
  @$pb.TagNumber(2)
  set senderChainKey(SenderKeyStateStructure_SenderChainKey v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSenderChainKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderChainKey() => clearField(2);
  @$pb.TagNumber(2)
  SenderKeyStateStructure_SenderChainKey ensureSenderChainKey() => $_ensure(1);

  @$pb.TagNumber(3)
  SenderKeyStateStructure_SenderSigningKey get senderSigningKey => $_getN(2);
  @$pb.TagNumber(3)
  set senderSigningKey(SenderKeyStateStructure_SenderSigningKey v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSenderSigningKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderSigningKey() => clearField(3);
  @$pb.TagNumber(3)
  SenderKeyStateStructure_SenderSigningKey ensureSenderSigningKey() =>
      $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<SenderKeyStateStructure_SenderMessageKey> get senderMessageKeys =>
      $_getList(3);
}

class SenderKeyRecordStructure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SenderKeyRecordStructure',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..pc<SenderKeyStateStructure>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'senderKeyStates',
        $pb.PbFieldType.PM,
        protoName: 'senderKeyStates',
        subBuilder: SenderKeyStateStructure.create)
    ..hasRequiredFields = false;

  SenderKeyRecordStructure._() : super();
  factory SenderKeyRecordStructure({
    $core.Iterable<SenderKeyStateStructure>? senderKeyStates,
  }) {
    final _result = create();
    if (senderKeyStates != null) {
      _result.senderKeyStates.addAll(senderKeyStates);
    }
    return _result;
  }
  factory SenderKeyRecordStructure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SenderKeyRecordStructure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SenderKeyRecordStructure clone() =>
      SenderKeyRecordStructure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SenderKeyRecordStructure copyWith(
          void Function(SenderKeyRecordStructure) updates) =>
      super.copyWith((message) => updates(message as SenderKeyRecordStructure))
          as SenderKeyRecordStructure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyRecordStructure create() => SenderKeyRecordStructure._();
  SenderKeyRecordStructure createEmptyInstance() => create();
  static $pb.PbList<SenderKeyRecordStructure> createRepeated() =>
      $pb.PbList<SenderKeyRecordStructure>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyRecordStructure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SenderKeyRecordStructure>(create);
  static SenderKeyRecordStructure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SenderKeyStateStructure> get senderKeyStates => $_getList(0);
}

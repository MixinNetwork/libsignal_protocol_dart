///
//  Generated code. Do not modify.
//  source: WhisperTextProtocol.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SignalMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SignalMessage', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'ratchetKey', $pb.PbFieldType.OY, protoName: 'ratchetKey')
    ..a<$core.int>(2, 'counter', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, 'previousCounter', $pb.PbFieldType.OU3, protoName: 'previousCounter')
    ..a<$core.List<$core.int>>(4, 'ciphertext', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SignalMessage._() : super();
  factory SignalMessage() => create();
  factory SignalMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SignalMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SignalMessage clone() => SignalMessage()..mergeFromMessage(this);
  SignalMessage copyWith(void Function(SignalMessage) updates) => super.copyWith((message) => updates(message as SignalMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignalMessage create() => SignalMessage._();
  SignalMessage createEmptyInstance() => create();
  static $pb.PbList<SignalMessage> createRepeated() => $pb.PbList<SignalMessage>();
  @$core.pragma('dart2js:noInline')
  static SignalMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalMessage>(create);
  static SignalMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ratchetKey => $_getN(0);
  @$pb.TagNumber(1)
  set ratchetKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRatchetKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearRatchetKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get counter => $_getIZ(1);
  @$pb.TagNumber(2)
  set counter($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCounter() => $_has(1);
  @$pb.TagNumber(2)
  void clearCounter() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get previousCounter => $_getIZ(2);
  @$pb.TagNumber(3)
  set previousCounter($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPreviousCounter() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreviousCounter() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get ciphertext => $_getN(3);
  @$pb.TagNumber(4)
  set ciphertext($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCiphertext() => $_has(3);
  @$pb.TagNumber(4)
  void clearCiphertext() => clearField(4);
}

class PreKeySignalMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PreKeySignalMessage', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.int>(1, 'preKeyId', $pb.PbFieldType.OU3, protoName: 'preKeyId')
    ..a<$core.List<$core.int>>(2, 'baseKey', $pb.PbFieldType.OY, protoName: 'baseKey')
    ..a<$core.List<$core.int>>(3, 'identityKey', $pb.PbFieldType.OY, protoName: 'identityKey')
    ..a<$core.List<$core.int>>(4, 'message', $pb.PbFieldType.OY)
    ..a<$core.int>(5, 'registrationId', $pb.PbFieldType.OU3, protoName: 'registrationId')
    ..a<$core.int>(6, 'signedPreKeyId', $pb.PbFieldType.OU3, protoName: 'signedPreKeyId')
    ..hasRequiredFields = false
  ;

  PreKeySignalMessage._() : super();
  factory PreKeySignalMessage() => create();
  factory PreKeySignalMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreKeySignalMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PreKeySignalMessage clone() => PreKeySignalMessage()..mergeFromMessage(this);
  PreKeySignalMessage copyWith(void Function(PreKeySignalMessage) updates) => super.copyWith((message) => updates(message as PreKeySignalMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PreKeySignalMessage create() => PreKeySignalMessage._();
  PreKeySignalMessage createEmptyInstance() => create();
  static $pb.PbList<PreKeySignalMessage> createRepeated() => $pb.PbList<PreKeySignalMessage>();
  @$core.pragma('dart2js:noInline')
  static PreKeySignalMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreKeySignalMessage>(create);
  static PreKeySignalMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set preKeyId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get baseKey => $_getN(1);
  @$pb.TagNumber(2)
  set baseKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get identityKey => $_getN(2);
  @$pb.TagNumber(3)
  set identityKey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIdentityKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdentityKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get message => $_getN(3);
  @$pb.TagNumber(4)
  set message($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get registrationId => $_getIZ(4);
  @$pb.TagNumber(5)
  set registrationId($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRegistrationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRegistrationId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get signedPreKeyId => $_getIZ(5);
  @$pb.TagNumber(6)
  set signedPreKeyId($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSignedPreKeyId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSignedPreKeyId() => clearField(6);
}

class KeyExchangeMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('KeyExchangeMessage', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.int>(1, 'id', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(2, 'baseKey', $pb.PbFieldType.OY, protoName: 'baseKey')
    ..a<$core.List<$core.int>>(3, 'ratchetKey', $pb.PbFieldType.OY, protoName: 'ratchetKey')
    ..a<$core.List<$core.int>>(4, 'identityKey', $pb.PbFieldType.OY, protoName: 'identityKey')
    ..a<$core.List<$core.int>>(5, 'baseKeySignature', $pb.PbFieldType.OY, protoName: 'baseKeySignature')
    ..hasRequiredFields = false
  ;

  KeyExchangeMessage._() : super();
  factory KeyExchangeMessage() => create();
  factory KeyExchangeMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KeyExchangeMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  KeyExchangeMessage clone() => KeyExchangeMessage()..mergeFromMessage(this);
  KeyExchangeMessage copyWith(void Function(KeyExchangeMessage) updates) => super.copyWith((message) => updates(message as KeyExchangeMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KeyExchangeMessage create() => KeyExchangeMessage._();
  KeyExchangeMessage createEmptyInstance() => create();
  static $pb.PbList<KeyExchangeMessage> createRepeated() => $pb.PbList<KeyExchangeMessage>();
  @$core.pragma('dart2js:noInline')
  static KeyExchangeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KeyExchangeMessage>(create);
  static KeyExchangeMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get baseKey => $_getN(1);
  @$pb.TagNumber(2)
  set baseKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get ratchetKey => $_getN(2);
  @$pb.TagNumber(3)
  set ratchetKey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRatchetKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearRatchetKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get identityKey => $_getN(3);
  @$pb.TagNumber(4)
  set identityKey($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIdentityKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdentityKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get baseKeySignature => $_getN(4);
  @$pb.TagNumber(5)
  set baseKeySignature($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBaseKeySignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearBaseKeySignature() => clearField(5);
}

class SenderKeyMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SenderKeyMessage', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.int>(1, 'id', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, 'iteration', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(3, 'ciphertext', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SenderKeyMessage._() : super();
  factory SenderKeyMessage() => create();
  factory SenderKeyMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SenderKeyMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SenderKeyMessage clone() => SenderKeyMessage()..mergeFromMessage(this);
  SenderKeyMessage copyWith(void Function(SenderKeyMessage) updates) => super.copyWith((message) => updates(message as SenderKeyMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyMessage create() => SenderKeyMessage._();
  SenderKeyMessage createEmptyInstance() => create();
  static $pb.PbList<SenderKeyMessage> createRepeated() => $pb.PbList<SenderKeyMessage>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SenderKeyMessage>(create);
  static SenderKeyMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get iteration => $_getIZ(1);
  @$pb.TagNumber(2)
  set iteration($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIteration() => $_has(1);
  @$pb.TagNumber(2)
  void clearIteration() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get ciphertext => $_getN(2);
  @$pb.TagNumber(3)
  set ciphertext($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCiphertext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCiphertext() => clearField(3);
}

class SenderKeyDistributionMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SenderKeyDistributionMessage', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.int>(1, 'id', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, 'iteration', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(3, 'chainKey', $pb.PbFieldType.OY, protoName: 'chainKey')
    ..a<$core.List<$core.int>>(4, 'signingKey', $pb.PbFieldType.OY, protoName: 'signingKey')
    ..hasRequiredFields = false
  ;

  SenderKeyDistributionMessage._() : super();
  factory SenderKeyDistributionMessage() => create();
  factory SenderKeyDistributionMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SenderKeyDistributionMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SenderKeyDistributionMessage clone() => SenderKeyDistributionMessage()..mergeFromMessage(this);
  SenderKeyDistributionMessage copyWith(void Function(SenderKeyDistributionMessage) updates) => super.copyWith((message) => updates(message as SenderKeyDistributionMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyDistributionMessage create() => SenderKeyDistributionMessage._();
  SenderKeyDistributionMessage createEmptyInstance() => create();
  static $pb.PbList<SenderKeyDistributionMessage> createRepeated() => $pb.PbList<SenderKeyDistributionMessage>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyDistributionMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SenderKeyDistributionMessage>(create);
  static SenderKeyDistributionMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get iteration => $_getIZ(1);
  @$pb.TagNumber(2)
  set iteration($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIteration() => $_has(1);
  @$pb.TagNumber(2)
  void clearIteration() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get chainKey => $_getN(2);
  @$pb.TagNumber(3)
  set chainKey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChainKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearChainKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get signingKey => $_getN(3);
  @$pb.TagNumber(4)
  set signingKey($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSigningKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearSigningKey() => clearField(4);
}

class DeviceConsistencyCodeMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeviceConsistencyCodeMessage', package: const $pb.PackageName('textsecure'), createEmptyInstance: create)
    ..a<$core.int>(1, 'generation', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(2, 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  DeviceConsistencyCodeMessage._() : super();
  factory DeviceConsistencyCodeMessage() => create();
  factory DeviceConsistencyCodeMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceConsistencyCodeMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeviceConsistencyCodeMessage clone() => DeviceConsistencyCodeMessage()..mergeFromMessage(this);
  DeviceConsistencyCodeMessage copyWith(void Function(DeviceConsistencyCodeMessage) updates) => super.copyWith((message) => updates(message as DeviceConsistencyCodeMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceConsistencyCodeMessage create() => DeviceConsistencyCodeMessage._();
  DeviceConsistencyCodeMessage createEmptyInstance() => create();
  static $pb.PbList<DeviceConsistencyCodeMessage> createRepeated() => $pb.PbList<DeviceConsistencyCodeMessage>();
  @$core.pragma('dart2js:noInline')
  static DeviceConsistencyCodeMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceConsistencyCodeMessage>(create);
  static DeviceConsistencyCodeMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get generation => $_getIZ(0);
  @$pb.TagNumber(1)
  set generation($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGeneration() => $_has(0);
  @$pb.TagNumber(1)
  void clearGeneration() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);
  @$pb.TagNumber(2)
  set signature($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignature() => clearField(2);
}


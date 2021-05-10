import 'dart:core';

import '../../IdentityKey.dart';
import '../../IdentityKeyPair.dart';
import '../../SignalProtocolAddress.dart';
import '../IdentityKeyStore.dart';
import '../PreKeyRecord.dart';
import '../SessionRecord.dart';
import '../SignalProtocolStore.dart';
import '../SignedPreKeyRecord.dart';
import 'InMemoryIdentityKeyStore.dart';
import 'InMemoryPreKeyStore.dart';
import 'InMemorySessionStore.dart';
import 'InMemorySignedPreKeyStore.dart';

class InMemorySignalProtocolStore implements SignalProtocolStore {
  final preKeyStore = InMemoryPreKeyStore();
  final sessionStore = InMemorySessionStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();

  var _identityKeyStore;

  InMemorySignalProtocolStore(
      IdentityKeyPair identityKeyPair, int registrationId) {
    _identityKeyStore =
        InMemoryIdentityKeyStore(identityKeyPair, registrationId);
  }
  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    return _identityKeyStore.getIdentityKeyPair();
  }

  @override
  Future<int> getLocalRegistrationId() async {
    return _identityKeyStore.getLocalRegistrationId();
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    return _identityKeyStore.saveIdentity(address, identityKey);
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction) async {
    return _identityKeyStore.isTrustedIdentity(address, identityKey, direction);
  }

  @override
  Future<IdentityKey> getIdentity(SignalProtocolAddress address) async {
    return _identityKeyStore.getIdentity(address);
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    return preKeyStore.loadPreKey(preKeyId);
  }

  @override
  void storePreKey(int preKeyId, PreKeyRecord record) {
    preKeyStore.storePreKey(preKeyId, record);
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    return preKeyStore.containsPreKey(preKeyId);
  }

  @override
  void removePreKey(int preKeyId) {
    preKeyStore.removePreKey(preKeyId);
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    return sessionStore.loadSession(address);
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    return sessionStore.getSubDeviceSessions(name);
  }

  @override
  Future storeSession(SignalProtocolAddress address, SessionRecord record) async {
    await sessionStore.storeSession(address, record);
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    return sessionStore.containsSession(address);
  }

  @override
  Future deleteSession(SignalProtocolAddress address) async {
    await sessionStore.deleteSession(address);
  }

  @override
  Future deleteAllSessions(String name) async {
    await sessionStore.deleteAllSessions(name);
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    return signedPreKeyStore.loadSignedPreKey(signedPreKeyId);
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    return signedPreKeyStore.loadSignedPreKeys();
  }

  @override
  void storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record) {
    signedPreKeyStore.storeSignedPreKey(signedPreKeyId, record);
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    return signedPreKeyStore.containsSignedPreKey(signedPreKeyId);
  }

  @override
  void removeSignedPreKey(int signedPreKeyId) {
    signedPreKeyStore.removeSignedPreKey(signedPreKeyId);
  }
}

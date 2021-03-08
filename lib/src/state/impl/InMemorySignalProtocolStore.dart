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
  IdentityKeyPair getIdentityKeyPair() {
    return _identityKeyStore.getIdentityKeyPair();
  }

  @override
  int getLocalRegistrationId() {
    return _identityKeyStore.getLocalRegistrationId();
  }

  @override
  bool saveIdentity(SignalProtocolAddress address, IdentityKey? identityKey) {
    return _identityKeyStore.saveIdentity(address, identityKey);
  }

  @override
  bool isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction) {
    return _identityKeyStore.isTrustedIdentity(address, identityKey, direction);
  }

  @override
  IdentityKey getIdentity(SignalProtocolAddress address) {
    return _identityKeyStore.getIdentity(address);
  }

  @override
  PreKeyRecord loadPreKey(int preKeyId) {
    return preKeyStore.loadPreKey(preKeyId);
  }

  @override
  void storePreKey(int preKeyId, PreKeyRecord record) {
    preKeyStore.storePreKey(preKeyId, record);
  }

  @override
  bool containsPreKey(int preKeyId) {
    return preKeyStore.containsPreKey(preKeyId);
  }

  @override
  void removePreKey(int preKeyId) {
    preKeyStore.removePreKey(preKeyId);
  }

  @override
  SessionRecord loadSession(SignalProtocolAddress address) {
    return sessionStore.loadSession(address);
  }

  @override
  List<int> getSubDeviceSessions(String name) {
    return sessionStore.getSubDeviceSessions(name);
  }

  @override
  void storeSession(SignalProtocolAddress address, SessionRecord record) {
    sessionStore.storeSession(address, record);
  }

  @override
  bool containsSession(SignalProtocolAddress address) {
    return sessionStore.containsSession(address);
  }

  @override
  void deleteSession(SignalProtocolAddress address) {
    sessionStore.deleteSession(address);
  }

  @override
  void deleteAllSessions(String name) {
    sessionStore.deleteAllSessions(name);
  }

  @override
  SignedPreKeyRecord loadSignedPreKey(int signedPreKeyId) {
    return signedPreKeyStore.loadSignedPreKey(signedPreKeyId);
  }

  @override
  List<SignedPreKeyRecord> loadSignedPreKeys() {
    return signedPreKeyStore.loadSignedPreKeys();
  }

  @override
  void storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record) {
    signedPreKeyStore.storeSignedPreKey(signedPreKeyId, record);
  }

  @override
  bool containsSignedPreKey(int signedPreKeyId) {
    return signedPreKeyStore.containsSignedPreKey(signedPreKeyId);
  }

  @override
  void removeSignedPreKey(int signedPreKeyId) {
    signedPreKeyStore.removeSignedPreKey(signedPreKeyId);
  }
}

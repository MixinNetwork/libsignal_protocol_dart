import 'IdentityKeyStore.dart';
import 'PreKeyStore.dart';
import 'SessionStore.dart';
import 'SignedPreKeyStore.dart';

abstract class SignalProtocolStore extends IdentityKeyStore
    with PreKeyStore, SessionStore, SignedPreKeyStore {}

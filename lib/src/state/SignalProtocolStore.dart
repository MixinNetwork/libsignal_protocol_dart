import 'package:libsignalprotocoldart/src/state/IdentityKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/PreKeyStore.dart';
import 'package:libsignalprotocoldart/src/state/SessionStore.dart';
import 'package:libsignalprotocoldart/src/state/SignedPreKeyStore.dart';

abstract class SignalProtocolStore extends IdentityKeyStore
    with PreKeyStore, SessionStore, SignedPreKeyStore {}

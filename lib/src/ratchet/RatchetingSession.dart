import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../ecc/Curve.dart';
import '../ecc/ECKeyPair.dart';
import '../ecc/ECPublicKey.dart';
import '../kdf/HKDF.dart';
import '../kdf/HKDFv3.dart';
import '../protocol/CiphertextMessage.dart';
import '../ratchet/AliceSignalProtocolParameters.dart';
import '../ratchet/BobSignalProtocolParameters.dart';
import '../ratchet/ChainKey.dart';
import '../ratchet/RootKey.dart';
import '../ratchet/SymmetricSignalProtocolParameters.dart';
import '../state/SessionState.dart';
import '../util/ByteUtil.dart';
import 'package:optional/optional.dart';

class RatchetingSession {
  static void initializeSession(
      SessionState sessionState, SymmetricSignalProtocolParameters parameters) {
    if (isAlice(parameters.getOurBaseKey().publicKey,
        parameters.getTheirBaseKey())) {
      var aliceParameters = AliceSignalProtocolParameters.newBuilder();

      aliceParameters
          .setOurBaseKey(parameters.getOurBaseKey())
          .setOurIdentityKey(parameters.getOurIdentityKey())
          .setTheirRatchetKey(parameters.getTheirRatchetKey())
          .setTheirIdentityKey(parameters.getTheirIdentityKey())
          .setTheirSignedPreKey(parameters.getTheirBaseKey())
          .setTheirOneTimePreKey(Optional<ECPublicKey>.empty());

      RatchetingSession.initializeSessionAlice(
          sessionState, aliceParameters.create());
    } else {
      var bobParameters = BobSignalProtocolParameters.newBuilder();

      bobParameters
          .setOurIdentityKey(parameters.getOurIdentityKey())
          .setOurRatchetKey(parameters.getOurRatchetKey())
          .setOurSignedPreKey(parameters.getOurBaseKey())
          .setOurOneTimePreKey(Optional<ECKeyPair>.empty())
          .setTheirBaseKey(parameters.getTheirBaseKey())
          .setTheirIdentityKey(parameters.getTheirIdentityKey());

      RatchetingSession.initializeSessionBob(
          sessionState, bobParameters.create());
    }
  }

  static void initializeSessionAlice(
      SessionState sessionState, AliceSignalProtocolParameters parameters) {
    try {
      sessionState.sessionVersion = CiphertextMessage.CURRENT_VERSION;
      sessionState.remoteIdentityKey = parameters.getTheirIdentityKey();
      sessionState.localIdentityKey =
          parameters.getOurIdentityKey().getPublicKey();

      var sendingRatchetKey = Curve.generateKeyPair();
      var secrets = Uint8List(0);

      secrets.addAll(getDiscontinuityBytes());

      secrets.addAll(Curve.calculateAgreement(parameters.getTheirSignedPreKey(),
          parameters.getOurIdentityKey().getPrivateKey()));
      secrets.addAll(Curve.calculateAgreement(
          parameters.getTheirIdentityKey().getPublicKey(),
          parameters.getOurBaseKey().privateKey));
      secrets.addAll(Curve.calculateAgreement(parameters.getTheirSignedPreKey(),
          parameters.getOurBaseKey().privateKey));

      if (parameters.getTheirOneTimePreKey().isPresent) {
        secrets.addAll(Curve.calculateAgreement(
            parameters.getTheirOneTimePreKey().value,
            parameters.getOurBaseKey().privateKey));
      }

      var derivedKeys = calculateDerivedKeys(secrets);
      var sendingChain = derivedKeys
          .getRootKey()
          .createChain(parameters.getTheirRatchetKey(), sendingRatchetKey);

      sessionState.addReceiverChain(
          parameters.getTheirRatchetKey(), derivedKeys.getChainKey());
      sessionState.setSenderChain(sendingRatchetKey, sendingChain.item2);
      sessionState.rootKey = sendingChain.item1;
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  static void initializeSessionBob(
      SessionState sessionState, BobSignalProtocolParameters parameters) {
    try {
      sessionState.sessionVersion = CiphertextMessage.CURRENT_VERSION;
      sessionState.remoteIdentityKey = parameters.getTheirIdentityKey();
      sessionState.localIdentityKey =
          parameters.getOurIdentityKey().getPublicKey();

      var secrets = Uint8List(0);

      secrets.addAll(getDiscontinuityBytes());

      secrets.addAll(Curve.calculateAgreement(
          parameters.getTheirIdentityKey().getPublicKey(),
          parameters.getOurSignedPreKey().privateKey));
      secrets.addAll(Curve.calculateAgreement(parameters.getTheirBaseKey(),
          parameters.getOurIdentityKey().getPrivateKey()));
      secrets.addAll(Curve.calculateAgreement(parameters.getTheirBaseKey(),
          parameters.getOurSignedPreKey().privateKey));

      if (parameters.getOurOneTimePreKey().isPresent) {
        secrets.addAll(Curve.calculateAgreement(parameters.getTheirBaseKey(),
            parameters.getOurOneTimePreKey().value.privateKey));
      }

      var derivedKeys = calculateDerivedKeys(secrets);

      sessionState.setSenderChain(
          parameters.getOurRatchetKey(), derivedKeys.getChainKey());
      sessionState.rootKey = derivedKeys.getRootKey();
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  static Uint8List getDiscontinuityBytes() {
    var discontinuity = Uint8List(32);
    for (var i = 0, len = discontinuity.length; i < len; i++) {
      discontinuity[i] = 0xFF;
    }
    return discontinuity;
  }

  static DerivedKeys calculateDerivedKeys(Uint8List masterSecret) {
    HKDF kdf = HKDFv3();
    var bytes = utf8.encode('WhisperText');
    var derivedSecretBytes = kdf.deriveSecrets(masterSecret, bytes, 64);
    var derivedSecrets =
        ByteUtil.splitTwo(derivedSecretBytes, 32, 32);

    return DerivedKeys(RootKey(kdf, derivedSecrets[0]),
        ChainKey(kdf, derivedSecrets[1], 0));
  }

  static bool isAlice(ECPublicKey ourKey, ECPublicKey theirKey) {
    return ourKey.compareTo(theirKey) < 0;
  }
}

class DerivedKeys {
  final RootKey _rootKey;
  final ChainKey _chainKey;

  DerivedKeys(this._rootKey, this._chainKey);

  RootKey getRootKey() {
    return _rootKey;
  }

  ChainKey getChainKey() {
    return _chainKey;
  }
}

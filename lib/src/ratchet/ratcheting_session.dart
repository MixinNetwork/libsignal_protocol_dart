import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:optional/optional.dart';

import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../kdf/hkdf.dart';
import '../kdf/hkdfv3.dart';
import '../protocol/ciphertext_message.dart';
import '../ratchet/alice_signal_protocol_parameters.dart';
import '../ratchet/bob_signal_protocol_parameters.dart';
import '../ratchet/chain_key.dart';
import '../ratchet/root_key.dart';
import '../ratchet/symmetric_signal_protocol_parameters.dart';
import '../state/session_state.dart';
import '../util/byte_util.dart';

class RatchetingSession {
  static void initializeSession(
      SessionState sessionState, SymmetricSignalProtocolParameters parameters) {
    if (isAlice(
        parameters.getOurBaseKey().publicKey, parameters.getTheirBaseKey())) {
      final aliceParameters = AliceSignalProtocolParameters.newBuilder();

      aliceParameters
          .setOurBaseKey(parameters.getOurBaseKey())
          .setOurIdentityKey(parameters.getOurIdentityKey())
          .setTheirRatchetKey(parameters.getTheirRatchetKey())
          .setTheirIdentityKey(parameters.getTheirIdentityKey())
          .setTheirSignedPreKey(parameters.getTheirBaseKey())
          .setTheirOneTimePreKey(const Optional<ECPublicKey>.empty());

      RatchetingSession.initializeSessionAlice(
          sessionState, aliceParameters.create());
    } else {
      final bobParameters = BobSignalProtocolParameters.newBuilder();

      bobParameters
          .setOurIdentityKey(parameters.getOurIdentityKey())
          .setOurRatchetKey(parameters.getOurRatchetKey())
          .setOurSignedPreKey(parameters.getOurBaseKey())
          .setOurOneTimePreKey(const Optional<ECKeyPair>.empty())
          .setTheirBaseKey(parameters.getTheirBaseKey())
          .setTheirIdentityKey(parameters.getTheirIdentityKey());

      RatchetingSession.initializeSessionBob(
          sessionState, bobParameters.create());
    }
  }

  static void initializeSessionAlice(
      SessionState sessionState, AliceSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.getTheirIdentityKey()
        ..localIdentityKey = parameters.getOurIdentityKey().getPublicKey();

      final sendingRatchetKey = Curve.generateKeyPair();
      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.getTheirSignedPreKey(),
            parameters.getOurIdentityKey().getPrivateKey()),
        ...Curve.calculateAgreement(parameters.getTheirIdentityKey().publicKey,
            parameters.getOurBaseKey().privateKey),
        ...Curve.calculateAgreement(parameters.getTheirSignedPreKey(),
            parameters.getOurBaseKey().privateKey)
      ];

      if (parameters.getTheirOneTimePreKey().isPresent) {
        secrets.addAll(Curve.calculateAgreement(
            parameters.getTheirOneTimePreKey().value,
            parameters.getOurBaseKey().privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));
      final sendingChain = derivedKeys
          .getRootKey()
          .createChain(parameters.getTheirRatchetKey(), sendingRatchetKey);

      sessionState
        ..addReceiverChain(
            parameters.getTheirRatchetKey(), derivedKeys.getChainKey())
        ..setSenderChain(sendingRatchetKey, sendingChain.item2)
        ..rootKey = sendingChain.item1;
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  static void initializeSessionBob(
      SessionState sessionState, BobSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.getTheirIdentityKey()
        ..localIdentityKey = parameters.getOurIdentityKey().getPublicKey();

      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.getTheirIdentityKey().publicKey,
            parameters.getOurSignedPreKey().privateKey),
        ...Curve.calculateAgreement(parameters.getTheirBaseKey(),
            parameters.getOurIdentityKey().getPrivateKey()),
        ...Curve.calculateAgreement(parameters.getTheirBaseKey(),
            parameters.getOurSignedPreKey().privateKey)
      ];
      if (parameters.getOurOneTimePreKey().isPresent) {
        secrets.addAll(Curve.calculateAgreement(parameters.getTheirBaseKey(),
            parameters.getOurOneTimePreKey().value.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));

      sessionState
        ..setSenderChain(
            parameters.getOurRatchetKey(), derivedKeys.getChainKey())
        ..rootKey = derivedKeys.getRootKey();
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  static Uint8List getDiscontinuityBytes() {
    final discontinuity = Uint8List(32);
    final len = discontinuity.length;
    for (var i = 0; i < len; i++) {
      discontinuity[i] = 0xFF;
    }
    return discontinuity;
  }

  static DerivedKeys calculateDerivedKeys(Uint8List masterSecret) {
    final HKDF kdf = HKDFv3();
    final bytes = Uint8List.fromList(utf8.encode('WhisperText'));
    final derivedSecretBytes = kdf.deriveSecrets(masterSecret, bytes, 64);
    final derivedSecrets = ByteUtil.splitTwo(derivedSecretBytes, 32, 32);

    return DerivedKeys(
        RootKey(kdf, derivedSecrets[0]), ChainKey(kdf, derivedSecrets[1], 0));
  }

  static bool isAlice(ECPublicKey ourKey, ECPublicKey theirKey) =>
      ourKey.compareTo(theirKey) < 0;
}

class DerivedKeys {
  DerivedKeys(this._rootKey, this._chainKey);

  final RootKey _rootKey;
  final ChainKey _chainKey;

  RootKey getRootKey() => _rootKey;

  ChainKey getChainKey() => _chainKey;
}

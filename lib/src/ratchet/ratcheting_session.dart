import 'dart:convert';
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
    if (isAlice(parameters.ourBaseKey.publicKey, parameters.theirBaseKey)) {
      final aliceParameters = AliceSignalProtocolParameters(
        ourBaseKey: parameters.ourBaseKey,
        ourIdentityKey: parameters.ourIdentityKey,
        theirRatchetKey: parameters.theirRatchetKey,
        theirIdentityKey: parameters.theirIdentityKey,
        theirSignedPreKey: parameters.theirBaseKey,
        theirOneTimePreKey: const Optional<ECPublicKey>.empty(),
      );
      RatchetingSession.initializeSessionAlice(sessionState, aliceParameters);
    } else {
      final bobParameters = BobSignalProtocolParameters(
        ourIdentityKey: parameters.ourIdentityKey,
        ourRatchetKey: parameters.ourRatchetKey,
        ourSignedPreKey: parameters.ourBaseKey,
        ourOneTimePreKey: const Optional<ECKeyPair>.empty(),
        theirBaseKey: parameters.theirBaseKey,
        theirIdentityKey: parameters.theirIdentityKey,
      );

      RatchetingSession.initializeSessionBob(sessionState, bobParameters);
    }
  }

  static void initializeSessionAlice(
      SessionState sessionState, AliceSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.theirIdentityKey
        ..localIdentityKey = parameters.ourIdentityKey.getPublicKey();

      final sendingRatchetKey = Curve.generateKeyPair();
      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.theirSignedPreKey,
            parameters.ourIdentityKey.getPrivateKey()),
        ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
            parameters.ourBaseKey.privateKey),
        ...Curve.calculateAgreement(
            parameters.theirSignedPreKey, parameters.ourBaseKey.privateKey)
      ];

      if (parameters.theirOneTimePreKey.isPresent) {
        secrets.addAll(Curve.calculateAgreement(
            parameters.theirOneTimePreKey.value,
            parameters.ourBaseKey.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));
      final sendingChain = derivedKeys
          .getRootKey()
          .createChain(parameters.theirRatchetKey, sendingRatchetKey);

      sessionState
        ..addReceiverChain(
            parameters.theirRatchetKey, derivedKeys.getChainKey())
        ..setSenderChain(sendingRatchetKey, sendingChain.item2)
        ..rootKey = sendingChain.item1;
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  static void initializeSessionBob(
      SessionState sessionState, BobSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.theirIdentityKey
        ..localIdentityKey = parameters.ourIdentityKey.getPublicKey();

      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
            parameters.ourSignedPreKey.privateKey),
        ...Curve.calculateAgreement(
            parameters.theirBaseKey, parameters.ourIdentityKey.getPrivateKey()),
        ...Curve.calculateAgreement(
            parameters.theirBaseKey, parameters.ourSignedPreKey.privateKey)
      ];
      if (parameters.ourOneTimePreKey.isPresent) {
        secrets.addAll(Curve.calculateAgreement(parameters.theirBaseKey,
            parameters.ourOneTimePreKey.value.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));

      sessionState
        ..setSenderChain(parameters.ourRatchetKey, derivedKeys.getChainKey())
        ..rootKey = derivedKeys.getRootKey();
    } on Exception catch (e) {
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

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignalprotocoldart/src/ecc/Curve.dart';
import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';
import 'package:libsignalprotocoldart/src/kdf/HKDF.dart';
import 'package:libsignalprotocoldart/src/kdf/HKDFv3.dart';
import 'package:libsignalprotocoldart/src/protocol/CiphertextMessage.dart';
import 'package:libsignalprotocoldart/src/ratchet/AliceSignalProtocolParameters.dart';
import 'package:libsignalprotocoldart/src/ratchet/BobSignalProtocolParameters.dart';
import 'package:libsignalprotocoldart/src/ratchet/ChainKey.dart';
import 'package:libsignalprotocoldart/src/ratchet/RootKey.dart';
import 'package:libsignalprotocoldart/src/ratchet/SymmetricSignalProtocolParameters.dart';
import 'package:libsignalprotocoldart/src/state/SessionState.dart';
import 'package:libsignalprotocoldart/src/util/ByteUtil.dart';
import 'package:optional/optional.dart';

class RatchetingSession {
/*
  static void initializeSession(SessionState sessionState, SymmetricSignalProtocolParameters parameters)
  {
    if (isAlice(parameters.getOurBaseKey().getPublicKey(), parameters.getTheirBaseKey())) {
     var aliceParameters = AliceSignalProtocolParameters.newBuilder();

      aliceParameters.setOurBaseKey(parameters.getOurBaseKey())
                     .setOurIdentityKey(parameters.getOurIdentityKey())
                     .setTheirRatchetKey(parameters.getTheirRatchetKey())
                     .setTheirIdentityKey(parameters.getTheirIdentityKey())
                     .setTheirSignedPreKey(parameters.getTheirBaseKey())
                     .setTheirOneTimePreKey(Optional<ECPublicKey>.empty());

      RatchetingSession.initializeSession(sessionState, aliceParameters.create());
    } else {
      var bobParameters = BobSignalProtocolParameters.newBuilder();

      bobParameters.setOurIdentityKey(parameters.getOurIdentityKey())
                   .setOurRatchetKey(parameters.getOurRatchetKey())
                   .setOurSignedPreKey(parameters.getOurBaseKey())
                   .setOurOneTimePreKey(Optional<ECKeyPair>.empty())
                   .setTheirBaseKey(parameters.getTheirBaseKey())
                   .setTheirIdentityKey(parameters.getTheirIdentityKey());

      RatchetingSession.initializeSession(sessionState, bobParameters.create());
    }
  }

   static void initializeSession(SessionState sessionState, AliceSignalProtocolParameters parameters)
  {
    try {
      sessionState.setSessionVersion(CiphertextMessage.CURRENT_VERSION);
      sessionState.setRemoteIdentityKey(parameters.getTheirIdentityKey());
      sessionState.setLocalIdentityKey(parameters.getOurIdentityKey().getPublicKey());

      ECKeyPair             sendingRatchetKey = Curve.generateKeyPair();
      ByteArrayOutputStream secrets           = new ByteArrayOutputStream();

      secrets.write(getDiscontinuityBytes());

      secrets.write(Curve.calculateAgreement(parameters.getTheirSignedPreKey(),
                                             parameters.getOurIdentityKey().getPrivateKey()));
      secrets.write(Curve.calculateAgreement(parameters.getTheirIdentityKey().getPublicKey(),
                                             parameters.getOurBaseKey().getPrivateKey()));
      secrets.write(Curve.calculateAgreement(parameters.getTheirSignedPreKey(),
                                             parameters.getOurBaseKey().getPrivateKey()));

      if (parameters.getTheirOneTimePreKey().isPresent()) {
        secrets.write(Curve.calculateAgreement(parameters.getTheirOneTimePreKey().get(),
                                               parameters.getOurBaseKey().getPrivateKey()));
      }

      DerivedKeys             derivedKeys  = calculateDerivedKeys(secrets.toByteArray());
      Pair<RootKey, ChainKey> sendingChain = derivedKeys.getRootKey().createChain(parameters.getTheirRatchetKey(), sendingRatchetKey);

      sessionState.addReceiverChain(parameters.getTheirRatchetKey(), derivedKeys.getChainKey());
      sessionState.setSenderChain(sendingRatchetKey, sendingChain.second());
      sessionState.setRootKey(sendingChain.first());
    } catch (IOException e) {
      throw AssertionError(e);
    }
  }

   static void initializeSession(SessionState sessionState, BobSignalProtocolParameters parameters)
  {

    try {
      sessionState.setSessionVersion(CiphertextMessage.CURRENT_VERSION);
      sessionState.setRemoteIdentityKey(parameters.getTheirIdentityKey());
      sessionState.setLocalIdentityKey(parameters.getOurIdentityKey().getPublicKey());

      ByteArrayOutputStream secrets = new ByteArrayOutputStream();

      secrets.write(getDiscontinuityBytes());

      secrets.write(Curve.calculateAgreement(parameters.getTheirIdentityKey().getPublicKey(),
                                             parameters.getOurSignedPreKey().getPrivateKey()));
      secrets.write(Curve.calculateAgreement(parameters.getTheirBaseKey(),
                                             parameters.getOurIdentityKey().getPrivateKey()));
      secrets.write(Curve.calculateAgreement(parameters.getTheirBaseKey(),
                                             parameters.getOurSignedPreKey().getPrivateKey()));

      if (parameters.getOurOneTimePreKey().isPresent()) {
        secrets.write(Curve.calculateAgreement(parameters.getTheirBaseKey(),
                                               parameters.getOurOneTimePreKey().get().getPrivateKey()));
      }

      DerivedKeys derivedKeys = calculateDerivedKeys(secrets.toByteArray());

      sessionState.setSenderChain(parameters.getOurRatchetKey(), derivedKeys.getChainKey());
      sessionState.setRootKey(derivedKeys.getRootKey());
    } catch (IOException e) {
      throw new AssertionError(e);
    }
  }

  static Uint8List getDiscontinuityBytes() {
    Uint8List discontinuity = Uint8List(32);
            for (int i = 0, len = discontinuity.length; i < len; i++) {
              discontinuity[i] = 0xFF; 
            }
    return discontinuity;
  }

  static DerivedKeys calculateDerivedKeys(Uint8List masterSecret) {
    HKDF     kdf                = new HKDFv3();
    List<int> bytes = utf8.encode("WhisperText");
    Uint8List   derivedSecretBytes = kdf.deriveSecrets(masterSecret, bytes, 64);
    List<Uint8List> derivedSecrets     = ByteUtil.splitTwo(derivedSecretBytes, 32, 32);

    return new DerivedKeys(new RootKey(kdf, derivedSecrets[0]),
                           new ChainKey(kdf, derivedSecrets[1], 0));
  }

   static bool isAlice(ECPublicKey ourKey, ECPublicKey theirKey) {
    return ourKey.compareTo(theirKey) < 0;
  }
*/

}

class DerivedKeys {
  final RootKey _rootKey;
  final ChainKey _chainKey;

  DerivedKeys(this._rootKey, this._chainKey) {}

  RootKey getRootKey() {
    return _rootKey;
  }

  ChainKey getChainKey() {
    return _chainKey;
  }
}

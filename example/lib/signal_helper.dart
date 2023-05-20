import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignalDataModel {
  String name;
  InMemorySignalProtocolStore signalStore;
  InMemorySenderKeyStore senderKeyStore;
  Map<String, dynamic> serverKeyBundle;
  SignalDataModel({
    required this.name,
    required this.serverKeyBundle,
    required this.senderKeyStore,
    required this.signalStore,
  });

  //
  String get getPreKeyBundleFromServer {
    // Server deletes a pre key it sends
    Map<String, dynamic> data = Map.from(serverKeyBundle);
    data.remove('preKeys');
    if (serverKeyBundle['preKeys'].isNotEmpty) {
      data['preKey'] = serverKeyBundle['preKeys'].first;
      serverKeyBundle['preKeys'].removeAt(0);
    }
    return jsonEncode(data);
  }

  // Session validation
  Future<Fingerprint?> generateSessionFingerPrint(String target) async {
    try {
      IdentityKey? targetIdentity = await signalStore.getIdentity(
          SignalProtocolAddress(target, SignalHelper.defaultDeviceId));
      if (targetIdentity != null) {
        final generator = NumericFingerprintGenerator(5200);
        final localFingerprint = generator.createFor(
          1,
          Uint8List.fromList(utf8.encode(name)),
          (await signalStore.getIdentityKeyPair()).getPublicKey(),
          Uint8List.fromList(utf8.encode(target)),
          targetIdentity,
        );
        return localFingerprint;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

// Group implementation
  Future<String> createGroupSession(String groupName) async {
    SignalProtocolAddress senderName =
        SignalProtocolAddress(name, SignalHelper.defaultDeviceId);
    SenderKeyName groupSender = SenderKeyName(groupName, senderName);
    GroupSessionBuilder sessionBuilder = GroupSessionBuilder(senderKeyStore);
    SenderKeyDistributionMessageWrapper distributionMessage =
        await sessionBuilder.create(groupSender);
    Map<String, dynamic> temp = {
      "from": name,
      "msg": base64Encode(distributionMessage.serialize()),
      "type": CiphertextMessage.senderKeyDistributionType,
    };
    String kdmMsg = jsonEncode(temp);
    return kdmMsg;
  }

  Future<String?> getGroupEncryptedText(String groupName, String text) async {
    try {
      SenderKeyName senderKeyName = SenderKeyName(
          groupName, SignalProtocolAddress(name, SignalHelper.defaultDeviceId));
      GroupCipher groupSession = GroupCipher(senderKeyStore, senderKeyName);
      Uint8List cipherText =
          await groupSession.encrypt(Uint8List.fromList(utf8.encode(text)));
      Map<String, dynamic> data = {
        "from": name,
        "msg": base64Encode(cipherText),
        "type": CiphertextMessage.senderKeyType,
      };
      return jsonEncode(data);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> registerKdm(String groupName, String kdm) async {
    try {
      Map data = jsonDecode(kdm);
      if (data["type"] == CiphertextMessage.senderKeyDistributionType) {
        SenderKeyName groupSender = SenderKeyName(groupName,
            SignalProtocolAddress(data['from'], SignalHelper.defaultDeviceId));
        GroupSessionBuilder sessionBuilder =
            GroupSessionBuilder(senderKeyStore);
        SenderKeyDistributionMessageWrapper distributionMessage =
            SenderKeyDistributionMessageWrapper.fromSerialized(
                base64Decode(data['msg']));
        await sessionBuilder.process(groupSender, distributionMessage);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> getGroupDecryptedText(String groupName, String msg) async {
    try {
      Map data = jsonDecode(msg);
      SenderKeyName skey = SenderKeyName(groupName,
          SignalProtocolAddress(data["from"], SignalHelper.defaultDeviceId));
      GroupCipher groupCipher = GroupCipher(senderKeyStore, skey);
      final plainText = await groupCipher.decrypt(base64Decode(data['msg']));
      return utf8.decode(plainText);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

// one to one implementation
  Future<void> buildSession(
    String target,
    String remoteBundle,
  ) async {
    SignalProtocolAddress targetAddress =
        SignalProtocolAddress(target, SignalHelper.defaultDeviceId);
    SessionBuilder sessionBuilder =
        SessionBuilder.fromSignalStore(signalStore, targetAddress);
    PreKeyBundle temp = preKeyBundleFromJson(remoteBundle);
    await sessionBuilder.processPreKeyBundle(temp);
  }

  PreKeyBundle preKeyBundleFromJson(String json) {
    Map<String, dynamic> remoteBundle = jsonDecode(json);
    // One time pre key calculation
    ECPublicKey? tempPrePublicKey;
    int? tempPreKeyId;
    if (remoteBundle["preKey"] != null) {
      tempPrePublicKey = Curve.decodePoint(
          DjbECPublicKey(base64Decode(remoteBundle["preKey"]['key']))
              .serialize(),
          1);
      tempPreKeyId = remoteBundle["preKey"]['id'];
    }
    // Signed pre key calculation
    int tempSignedPreKeyId = remoteBundle["signedPreKey"]['id'];
    Map? tempSignedPreKey = remoteBundle["signedPreKey"];
    ECPublicKey? tempSignedPreKeyPublic;
    Uint8List? tempSignedPreKeySignature;
    if (tempSignedPreKey != null) {
      tempSignedPreKeyPublic = Curve.decodePoint(
          DjbECPublicKey(base64Decode(remoteBundle["signedPreKey"]['key']))
              .serialize(),
          1);
      tempSignedPreKeySignature =
          base64Decode(remoteBundle["signedPreKey"]['signature']);
    }
    // Identity key calculation
    IdentityKey tempIdentityKey = IdentityKey(Curve.decodePoint(
        DjbECPublicKey(base64Decode(remoteBundle["identityKey"])).serialize(),
        1));
    return PreKeyBundle(
      remoteBundle['registrationId'],
      1,
      tempPreKeyId,
      tempPrePublicKey,
      tempSignedPreKeyId,
      tempSignedPreKeyPublic,
      tempSignedPreKeySignature,
      tempIdentityKey,
    );
  }

  Future<String?> getEncryptedText(String text, String target) async {
    try {
      SessionCipher session = SessionCipher.fromStore(signalStore,
          SignalProtocolAddress(target, SignalHelper.defaultDeviceId));
      final ciphertext =
          await session.encrypt(Uint8List.fromList(utf8.encode(text)));
      Map<String, dynamic> data = {
        "msg": base64Encode(ciphertext.serialize()),
        "type": ciphertext.getType(),
      };
      return jsonEncode(data);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> getDecryptedText(String source, String msg) async {
    try {
      SessionCipher session = SessionCipher.fromStore(signalStore,
          SignalProtocolAddress(source, SignalHelper.defaultDeviceId));
      Map data = jsonDecode(msg);
      if (data["type"] == CiphertextMessage.prekeyType) {
        PreKeySignalMessage pre =
            PreKeySignalMessage(base64Decode(data["msg"]));
        Uint8List plaintext = await session.decrypt(pre);
        String dectext = utf8.decode(plaintext);
        return dectext;
      } else if (data["type"] == CiphertextMessage.whisperType) {
        SignalMessage signalMsg =
            SignalMessage.fromSerialized(base64Decode(data["msg"]));
        Uint8List plaintext = await session.decryptFromSignal(signalMsg);
        String dectext = utf8.decode(plaintext);
        return dectext;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

class SignalHelper {
  static const int defaultDeviceId = 1;

  static Future<SignalDataModel> getSignalModel(String name) async {
    final identityKeyPair = generateIdentityKeyPair();
    final registrationId = generateRegistrationId(true);
    InMemorySignalProtocolStore signalStore =
        InMemorySignalProtocolStore(identityKeyPair, registrationId);
    final preKeys = generatePreKeys(0, 5);
    final signedPreKey =
        generateSignedPreKey(identityKeyPair, SignalHelper.defaultDeviceId);
    for (final p in preKeys) {
      await signalStore.preKeyStore.storePreKey(p.id, p);
    }
    await signalStore.signedPreKeyStore
        .storeSignedPreKey(signedPreKey.id, signedPreKey);
    //
    Map<String, dynamic> req = {};
    req['registrationId'] = registrationId;
    req['identityKey'] =
        base64Encode(identityKeyPair.getPublicKey().serialize());
    req['signedPreKey'] = {
      'id': signedPreKey.id,
      'signature': base64Encode(signedPreKey.signature),
      'key': base64Encode(signedPreKey.getKeyPair().publicKey.serialize()),
    };
    List pKeysList = [];
    for (PreKeyRecord pKey in preKeys) {
      Map<String, dynamic> pKeys = {};
      pKeys['id'] = pKey.id;
      pKeys['key'] = base64Encode(pKey.getKeyPair().publicKey.serialize());
      pKeysList.add(pKeys);
    }
    req['preKeys'] = pKeysList;
    //
    SignalDataModel sm = SignalDataModel(
      name: name,
      serverKeyBundle: req,
      senderKeyStore: InMemorySenderKeyStore(),
      signalStore: signalStore,
    );
    return sm;
  }
}

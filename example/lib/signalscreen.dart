import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'signal_helper.dart';

class SignalTestScreen extends StatefulWidget {
  const SignalTestScreen({super.key});

  @override
  State<SignalTestScreen> createState() => _SignalTestScreenState();
}

class _SignalTestScreenState extends State<SignalTestScreen> {
  SignalDataModel? aliceModel;
  SignalDataModel? bobModel;
  final String alice = "alice";
  final String bob = "bob";
  TextEditingController aliceMsgController = TextEditingController();
  TextEditingController bobMsgController = TextEditingController();
  String? bobEncryptedText;
  String? bobDecryptedText;
  String? aliceEncryptedText;
  String? aliceDecryptedText;
  Fingerprint? bobFingerprint;
  Fingerprint? aliceFingerprint;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    aliceMsgController.dispose();
    bobMsgController.dispose();
    super.dispose();
  }

  initialize() async {
    aliceModel = await SignalHelper.getSignalModel(alice);
    bobModel = await SignalHelper.getSignalModel(bob);
    // receiverKeyBundle contains the bundle that server will send to sender
    Map<String, dynamic> receiverKeyBundle = bobModel!.serverKeyBundle;
    log("$bob key bundle bundle that server will send to sender \n $receiverKeyBundle");
    await aliceModel!.buildSession(bob,
        receiverKeyBundle); // Building session can create fingerprint for this session. Fingerprint can be generated for both user when both users have created as session.
    setState(() {});
  }

  Widget getTitleTextWidget(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.indigo),
    );
  }

  Widget getExpansionTileWidget(String title, String body) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 5),
        childrenPadding: const EdgeInsets.all(5),
        expandedAlignment: Alignment.topLeft,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        children: <Widget>[
          Text(
            body,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget get mainBody {
    if ((aliceModel != null) && (bobModel != null)) {
      return ListView(
        padding: const EdgeInsets.all(5),
        children: [
          Card(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              children: [
                getTitleTextWidget("Alice side (Initiator)"),
                const SizedBox(height: 5),
                TextField(
                  controller: aliceMsgController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter Message',
                    hintText: 'Enter Message',
                  ),
                ),
                const SizedBox(height: 5),
                if (aliceFingerprint != null)
                  getExpansionTileWidget(
                      "Session fingerprint (Aka safety number):",
                      aliceFingerprint!.displayableFingerprint
                          .getDisplayText()),
                const SizedBox(height: 5),
                if (aliceEncryptedText != null)
                  getExpansionTileWidget("Received text:", aliceEncryptedText!),
                const SizedBox(height: 5),
                if (aliceDecryptedText != null)
                  getExpansionTileWidget(
                      "Decrypted text:", aliceDecryptedText!),
                const SizedBox(height: 5),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('SEND TO BOB'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (aliceMsgController.text.isEmpty) return;
                    String? text = await aliceModel!
                        .getEncryptedText(aliceMsgController.text, bob);
                    if (text != null) {
                      bobEncryptedText = text;
                      log("message from $alice: $text");
                      // Decryption on receiver end
                      String? decText =
                          await bobModel!.getDecryptedText(alice, text);
                      log("decrypted text on bob side: $decText");
                      bobDecryptedText = decText;
                    }
                    aliceMsgController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Card(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              children: [
                getTitleTextWidget("Bob side"),
                const SizedBox(height: 5),
                if (bobFingerprint != null)
                  getExpansionTileWidget(
                      "Session fingerprint (Aka safety number):",
                      bobFingerprint!.displayableFingerprint.getDisplayText()),
                const SizedBox(height: 5),
                if (bobEncryptedText != null)
                  getExpansionTileWidget("Received text:", bobEncryptedText!),
                const SizedBox(height: 5),
                if (bobDecryptedText != null)
                  getExpansionTileWidget("Decrypted text:", bobDecryptedText!),
                const SizedBox(height: 5),
                TextField(
                  controller: bobMsgController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter Message',
                    hintText: 'Enter Message',
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('SEND TO ALICE'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (bobMsgController.text.isEmpty) return;
                    String? text = await bobModel!
                        .getEncryptedText(bobMsgController.text, alice);
                    if (text != null) {
                      aliceEncryptedText = text;
                      log("message from $bob: $text");
                      // Decryption on receiver end
                      String? decText =
                          await aliceModel!.getDecryptedText(bob, text);
                      log("decrypted text on alice side: $decText");
                      aliceDecryptedText = decText;
                    }
                    bobMsgController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.fingerprint),
            label: const Text('Calculate session fingerprints'),
            onPressed: () async {
              aliceFingerprint =
                  await aliceModel!.generateSessionFingerPrint(bob);
              bobFingerprint =
                  await bobModel!.generateSessionFingerPrint(alice);
              setState(() {});
            },
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signal 1 to 1',
          style: TextStyle(fontSize: 15),
        ),
        toolbarHeight: 45,
        centerTitle: true,
      ),
      body: mainBody,
    );
  }
}

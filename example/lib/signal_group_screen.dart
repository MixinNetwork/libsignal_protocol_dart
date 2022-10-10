// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'signal_helper.dart';

class GroupParticipantsModel {
  String name;
  SignalDataModel model;
  TextEditingController msgController;
  String? encryptedText;
  String? decryptedText;
  GroupParticipantsModel({
    required this.name,
    required this.model,
    required this.msgController,
    this.encryptedText,
    this.decryptedText,
  });
}

class SignalTestGroupScreen extends StatefulWidget {
  const SignalTestGroupScreen({super.key});

  @override
  State<SignalTestGroupScreen> createState() => _SignalTestGroupScreenState();
}

class _SignalTestGroupScreenState extends State<SignalTestGroupScreen> {
  final faker = Faker.instance;
  final String groupName = "sample_group_name";
  Map<String, GroupParticipantsModel> participants = {};

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    for (GroupParticipantsModel participant in participants.values) {
      participant.msgController.dispose();
    }
    super.dispose();
  }

  addRandomParticipant() async {
    String name = faker.name.firstName();
    if (!participants.containsKey(name)) {
      SignalDataModel model = await SignalHelper.getSignalModel(name);
      // Sync kdm messages
      String kdm = await model.createGroupSession(groupName);
      for (GroupParticipantsModel participant in participants.values) {
        String participantKdm =
            await participant.model.createGroupSession(groupName);
        await participant.model.registerKdm(groupName, kdm);
        await model.registerKdm(groupName, participantKdm);
      }
      participants[name] = GroupParticipantsModel(
        name: name,
        model: model,
        msgController: TextEditingController(),
      );
    } else {
      await addRandomParticipant();
    }
    setState(() {});
  }

  initialize() async {
    await addRandomParticipant();
    await addRandomParticipant();
    await addRandomParticipant();
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

  Widget getGroupParticipantsModelWidget(GroupParticipantsModel model) {
    return Card(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: [
          getTitleTextWidget("${model.name}'s side"),
          const SizedBox(height: 5),
          TextField(
            controller: model.msgController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Enter Message',
              hintText: 'Enter Message',
            ),
          ),
          const SizedBox(height: 5),
          if (model.encryptedText != null)
            getExpansionTileWidget("Received text:", model.encryptedText!),
          const SizedBox(height: 5),
          if (model.decryptedText != null)
            getExpansionTileWidget("Decrypted text:", model.decryptedText!),
          const SizedBox(height: 5),
          ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('SEND TO GROUP'),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (model.msgController.text.isEmpty) return;
              String? text = await model.model
                  .getGroupEncryptedText(groupName, model.msgController.text);
              if (text != null) {
                log("${model.name} sent message to group (${participants.length - 1} participants): $text");
                for (GroupParticipantsModel participant
                    in participants.values) {
                  if (participant.name != model.name) {
                    participant.encryptedText = text;
                    log("${participant.name} received message: $text");
                    String? decText = await participant.model
                        .getGroupDecryptedText(groupName, text);
                    if (decText != null) {
                      participant.decryptedText = decText;
                      log("${participant.name} decrypted message: $decText");
                    }
                  }
                }
              }
              model.msgController.clear();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget get mainBody {
    if (participants.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<GroupParticipantsModel> temp = participants.values.toList();
    return ListView(
      padding: const EdgeInsets.all(5),
      children: List.generate(
          temp.length, (index) => getGroupParticipantsModelWidget(temp[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signal Group Messaging',
          style: TextStyle(fontSize: 15),
        ),
        toolbarHeight: 45,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addRandomParticipant,
        child: const Icon(Icons.person_add),
      ),
      body: mainBody,
    );
  }
}

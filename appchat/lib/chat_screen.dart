import 'dart:io';

import 'package:appchat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(child:
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("messages").snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<DocumentChange?>? documents= snapshot.data?.docs.map((doc) => doc.data()).cast<DocumentChange<Object?>?>().toList();

                  return ListView.builder(
                      itemCount: documents?.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        print("AQUUIII ${documents}");
                        return ListTile(
                          title: Text(documents?[index]?.doc["text"] ?? "aaaa"),
                        );
                      });
              }
            },
          ),),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }

  Future<void> _sendMessage({String? text, XFile? imageFile}) async {
    Map<String, dynamic> data = {};

    if (imageFile != null) {
      print("IMAGE FILE : ${imageFile.toString()}");

      Reference reference = FirebaseStorage.instance.ref();
      final TaskSnapshot snapshot = await reference
          .child(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString())
          .putFile(File(imageFile.path));
      final downloadUrl = await snapshot.ref.getDownloadURL();
      data["imageUrl"] = downloadUrl;
    }
    print("TEXT UP FIREBASE : ${text}");

    if (text != null) data["text"] = text;

    FirebaseDatabase.instance.ref("messages").set(data);
  }
}

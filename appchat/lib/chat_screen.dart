import 'dart:io';

import 'package:appchat/text_composer.dart';
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
      body: TextComposer(_sendMessage),
    );
  }

  Future<void> _sendMessage({String? text, XFile? imageFile}) async {

    if (imageFile != null) {

      Reference reference = FirebaseStorage.instance.ref();
      UploadTask task = reference
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = task.snapshot;
      String url = await taskSnapshot.ref.getDownloadURL();

      print("aqui o download link $url");

    }

    FirebaseDatabase.instance.ref("messages").set({"text": text});
  }
}

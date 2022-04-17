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
    Map<String, dynamic> data = {};

    if (imageFile != null) {
      print("IMAGE FILE : $imageFile");
      // DatabaseReference ref = FirebaseDatabase.instance.ref();
      // ref.child(DateTime.now().millisecondsSinceEpoch.toString());
      // UploadTask uploadTask = ref.set(File(imageFile.path));
      // TaskSnapshot taskSnapshot = await uploadTask;
      // var dowurl = await taskSnapshot.ref.getDownloadURL();
      // var url = dowurl.toString();
      // }

      // var path = File(imageFile.path);
      // Reference reference = FirebaseStorage.instance.ref();
      //
      // UploadTask task = reference
      //     .child(DateTime.now().millisecondsSinceEpoch.toString())
      //     .putFile(path);
      // TaskSnapshot taskSnapshot = task.snapshot;
      // String url = await taskSnapshot.ref.getDownloadURL();

      Reference reference = FirebaseStorage.instance.ref();
      final TaskSnapshot snapshot = await reference
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imageFile.path));
      final downloadUrl = await snapshot.ref.getDownloadURL();
      data["imageUrl"] = downloadUrl;
    }

    if(text != null) data["text"] = text;

    FirebaseDatabase.instance.ref("messages").set(data);

  }
}

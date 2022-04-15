import 'package:appchat/text_composer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void _sendMessage(String text) async{
    await Firebase.initializeApp();
    FirebaseDatabase.instance.ref("messages").set({"text": text});
  }


}

import 'package:appchat/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      title: "Chat With Flutter",
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.blue)),
    ),
  ));
}

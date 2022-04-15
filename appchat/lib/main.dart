import 'package:appchat/chat_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
    title: "Chat With Flutter",
    debugShowCheckedModeBanner: false,
    home: const ChatScreen(),
    theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Colors.blue)),
  ));
}

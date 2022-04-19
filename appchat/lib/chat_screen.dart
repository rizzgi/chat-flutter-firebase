import 'dart:io';

import 'package:appchat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? _currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //busca em Auth no firebase se há usuários, e preenche em _currentUser o usuário que se encontra logado no app.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  //Dentro do banco, se instancia MESSAGES, que é onde ficarão arquivadas as mensagens
                  FirebaseFirestore.instance.collection("messages").snapshots(),
              builder: (context, snapshot) {
                //snapshot está verificando se houve conexao
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    //caso n, ou caso carregando entao mostra-se um load
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    //Por padrão o snapshot retorna, entao acessamos a lista com ela revertida
                    List<DocumentSnapshot?>? documents =
                        snapshot.data?.docs.reversed.toList();
                    //e aí então a lista de documentos é exibida dentro do list view builder
                    return ListView.builder(
                        itemCount: documents?.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          print("AQUUIII ${documents}");
                          return ChatMessage(documents?[index]?.data()
                              as Map<String, dynamic>);
                        });
                }
              },
            ),
          ),
          //funcao que envia para a classe TextComposer os dados da msg que são enviados
          TextComposer(_sendMessage),
        ],
      ),
    );
  }

  //funcao que envia para o firebase firestore o texto ou imagem, e também dados do usuario
  Future<void> _sendMessage({String? text, XFile? imageFile}) async {
    User? user = await _getUser();

    if (user == null) {
      print("USER $user");
      _scaffoldState.currentState?.showSnackBar(const SnackBar(
          content: Text("Não foi possível fazer login. Tente novamente.")));
    }

    Map<String, dynamic> data = {
      "uid": user?.uid,
      "senderName": user?.displayName,
      "senderPhotoUrl": user?.photoURL,
    };

    if (imageFile != null) {
      //inicia um instancia no banco de storage
      Reference reference = FirebaseStorage.instance.ref();
      final TaskSnapshot snapshot = await reference
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imageFile.path));
      String downloadUrl = await snapshot.ref.getDownloadURL();
      data["imageUrl"] = downloadUrl;
    }
    if (text != null) data["text"] = text;
    FirebaseFirestore.instance.collection("messages").add(data);
  }

  //funcao para verificar se o usuario está conectado
  //se n estiver, solicita o login assim q enviar msg
  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      //conexao c firebase autenticacao
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken);
      final UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential?.user;
      return user;
    } catch (error) {
      print("error signin $error");
      return null;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  Function(String) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(onPressed: () {
            ImagePi
          }, icon: Icon(Icons.photo_camera)),
          Expanded(
            child: TextField(
                controller: _controller,
                decoration: const InputDecoration.collapsed(
                    hintText: "Escrever mensagem..."),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: (text) {
                  widget.sendMessage(text);
                  _reset();
                }),
          ),
          IconButton(
              onPressed: _isComposing ? () {
                widget.sendMessage(_controller.text);
                _reset();
              } : null,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  void _reset(){
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }
}

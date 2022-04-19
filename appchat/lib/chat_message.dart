import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data);
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(data["senderPhotoUrl"]),
          ),
          Expanded(
            child: Column(
              children: [
                data["imageUrl"] != null
                    ? Image.network(data["imageUrl"])
                    : Text(
                        data["text"],
                        style: const TextStyle(fontSize: 16),
                      ),
                Text(
                  data["senderName"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

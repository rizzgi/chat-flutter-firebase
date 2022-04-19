import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.mine);
  final Map<String, dynamic> data;
  final bool mine;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          !mine ?
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
             ),
          ) : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: mine? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data["imageUrl"] != null
                    ? Image.network(data["imageUrl"], width: 180, height: 220,)
                    : Text(
                        data["text"],
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(fontSize: 16),
                      ),
                Text(
                  data["senderName"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                )
              ],
            ),
          ),
          mine ?
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}

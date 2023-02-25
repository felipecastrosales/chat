import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.data,
    required this.isMine,
  });

  final Map<String, dynamic> data;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: <Widget>[
          isMine
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      data['senderPhotoUrl'],
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                data['imgUrl'] != null
                    ? Image.network(
                        data['imgUrl'],
                        width: 250,
                      )
                    : Text(
                        data['text'],
                        textAlign: isMine ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(fontSize: 18),
                      ),
                Text(
                  data['senderName'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          isMine
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      data['senderPhotoUrl'],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

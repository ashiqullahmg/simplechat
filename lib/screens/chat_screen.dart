import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String receiverName;
  final String receiverId;
  final String receiverAvatar;
  const ChatScreen(
      {Key? key,
      required this.receiverName,
      required this.receiverId,
      required this.receiverAvatar})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  CachedNetworkImageProvider(widget.receiverAvatar),
            ),
            SizedBox(
              width: 6.0,
            ),
            Text(
              widget.receiverName,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
    );
  }
}

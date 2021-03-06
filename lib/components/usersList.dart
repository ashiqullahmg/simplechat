import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplechat/screens/chat_screen.dart';

class UsersList extends StatelessWidget {
  final String id;
  final String currentUserId;
  final String name;
  final String about;
  final date;
  final String photo;
  final String searchValue;
  UsersList(
      {required this.id,
      required this.currentUserId,
      required this.name,
      required this.about,
      required this.date,
      required this.photo,
      required this.searchValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        currentUserId != id &&
                name.startsWith(searchValue) &&
                searchValue.isNotEmpty
            ? ListTile(
                horizontalTitleGap: 5,
                contentPadding: EdgeInsets.all(15),
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 25.0,
                  backgroundImage: NetworkImage('$photo'),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Joined: ' + DateFormat.yMMMMd().format(date),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(about),
                onTap: () {
                  print(name);
                  gotoChatScreen(context);
                })
            : Divider(
                thickness: 0,
                height: 0,
              ),
        Divider(
          thickness: 1,
          height: 0,
        )
      ],
    );
  }

  void gotoChatScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new ChatScreen(receiverId: id, receiverAvatar: photo, receiverName: name);
        },
      ),
    );
  }
}
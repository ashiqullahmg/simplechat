import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simplechat/screens/settings_screen.dart';
import 'package:simplechat/components/alertDialogSettings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
class MoreDrawer extends StatefulWidget {

  const MoreDrawer({Key? key}) : super(key: key);

  @override
  _MoreDrawerState createState() => _MoreDrawerState();
}

class _MoreDrawerState extends State<MoreDrawer> {
  late TextEditingController nameTextEditingController;
  late TextEditingController aboutTextEditingController;
  late SharedPreferences preferences;
  String id = "";
  String name = "";
  String about = "";
  String photoUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(children: _buildDrawerContent(context)),
      ),
    );
  }


  List<Widget> _buildDrawerContent(BuildContext context) {

    final drawerContent = <Widget>[];
    drawerContent.add(_buildDrawerHeader());
    drawerContent.addAll(_buildDrawerBody(context));
    return drawerContent;
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(name),
      accountEmail: Text(about),
      currentAccountPicture: CircleAvatar(
        backgroundImage: photoUrl.isNotEmpty ? CachedNetworkImageProvider(photoUrl) : null,
      ),
      // onDetailsPressed: () {
      //   print(name);
      // },
    );
  }

  List<Widget> _buildDrawerBody(BuildContext context) {
    return <Widget>[
      DrawerListTile(
        iconData: Icons.settings,
        title: 'Settings',
        onTilePressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsScreen()));
        },
      ),
      DrawerListTile(
        iconData: Icons.logout_outlined,
        title: 'Logout',
        onTilePressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.all(0),
                  title: Text('Hello , $name,'),
                  content: Text("Do you want to logout?"),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextButton(
                            child: Text("Yes"),
                            onPressed: () {
                              logoutUser();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                );
              });
        },
      ),
    ];
  }

  void readDataFromLocal() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString('id').toString();
      name = preferences.getString('name').toString();
      about = preferences.getString('about').toString();
      photoUrl = preferences.getString('photoUrl').toString();
    });
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }


}

class DrawerListTile extends StatefulWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTilePressed;
  const DrawerListTile(
      {Key? key, required this.iconData, required this.title, required this.onTilePressed})
      : super(key: key);

  @override
  _DrawerListTileState createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(widget.iconData),
      title: Text(widget.title, style: TextStyle(fontSize: 16)),
      onTap: widget.onTilePressed,
    );
  }
}

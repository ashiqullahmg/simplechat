import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplechat/constants.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  static const String id = 'home_screen';
  const HomeScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Simple Chat'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
                icon: Icon(FontAwesomeIcons.userCog))
          ],
        ),
        body: Column(
          children: [
            searchBar(),
            TextButton.icon(
              icon: Icon(FontAwesomeIcons.signOutAlt),
              label: Text('Logout'),
              onPressed: () {
                logoutUser();
              },
            ),
          ],
        ));
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(0.0),
      child: TextFormField(
        decoration: kTextFieldDecoration.copyWith(
            labelText: 'Search',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 35.0,
              ),
            )),
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black38,
        ),
        controller: searchTextEditingController,
      ),
    );
  }
}

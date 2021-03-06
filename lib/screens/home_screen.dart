import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplechat/components/moreDrawer.dart';
import 'package:simplechat/components/progress.dart';
import 'package:simplechat/components/usersList.dart';
import 'package:simplechat/constants.dart';
import 'package:simplechat/main.dart';
import 'package:intl/intl.dart';
import 'package:simplechat/screens/search_screen.dart';
import 'package:simplechat/utilities/capitilization.dart';
import 'package:simplechat/screens/settings_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  static const String id = 'home_screen';
  const HomeScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var queryResultSet = [];
  var tempSearch = [];
  @override
  void initState() {
    super.initState();
    searchPrevious();
  }
  late bool isSearch = false;
  late String searchValue = '';
  bool isTapped = false;
  bool isSearched = false;
  bool previousChat = false;
  var usersList;
  var preUsersList;
  late Future<QuerySnapshot> userFound;
  late Future<QuerySnapshot> preUserFound;
  TextEditingController searchTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Simple Chat'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = true;
                });
              },
              icon: Icon(FontAwesomeIcons.search, size: 15.0,))
        ],
      ),
      drawer: MoreDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isSearched
                ? Flexible(
                    child: ListView.builder(
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        return UsersList(
                          searchValue: searchValue,
                          currentUserId: widget.currentUserId,
                          id: usersList[index]['id'],
                          name: usersList[index]['name'],
                          about: usersList[index]['about'],
                          date: usersList[index]['createAt'].toDate(),
                          photo: usersList[index]['photoUrl'],
                        );
                      },
                    ),
                  )
                : isTapped
                    ? linearProgress()
                    : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.withOpacity(0.7),
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchScreen(currentUserId: widget.currentUserId)));
        },
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  showSnack(var message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  getUsers(searchValue) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: searchValue)
        .get();
  }

  search() {
    setState(() {
      isSearched = false;
    });
    userFound = getUsers(searchValue);
    userFound.then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(() {
          isSearched = true;
          usersList = docs.docs;
        });
      } else {
        return linearProgress();
      }
    });
  }

  Future searchPrevious() async{

   // userFound =  FirebaseFirestore.instance
   //      .collection('users')
   //      .doc('chatWith')
   //      .where('Ashiq Khan', isEqualTo: searchValue)
   //      .get();
  }

}


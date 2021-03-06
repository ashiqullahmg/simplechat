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
import 'package:simplechat/utilities/capitilization.dart';
import 'package:simplechat/screens/settings_screen.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;
  static const String id = 'home_screen';
  const SearchScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var queryResultSet = [];
  var tempSearch = [];
  @override
  void initState() {
    super.initState();
  }

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

        title: Text('Search Users'),
      ),
      drawer: MoreDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(0.0),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  setState(() {
                    isTapped = false;
                  });
                },
                onTap: () {
                  setState(() {
                    isTapped = true;
                  });
                },
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    searchValue = value.capitalizeFirstofEach;
                  });
                  search();
                },
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Enter a full name',
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black38,
                ),
                controller: searchTextEditingController,
              ),
            ),
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
  
}

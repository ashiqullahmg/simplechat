import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simplechat/components/progress.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplechat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences preferences;
  bool isLoggedIn = false;
  bool isLoading = false;
  late User currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return new HomeScreen(
                currentUserId: preferences.getString('id').toString());
          },
        ),
      );
    }
    this.setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Colors.blueAccent,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: AssetImage('images/logo.png'),
              ),
              Text(
                'Simple Chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CuteFont',
                  fontSize: 50.0,
                  color: Colors.orangeAccent,
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.blueAccent,
                ),
                label: Text(
                  'Signin with Google',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Roboto-Medium',
                    color: Colors.black38,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                onPressed: () {
                  singIn();
                },
              ),
              Padding(
                padding: EdgeInsets.all((10.0)),
                child: isLoading ? circularProgress() : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> singIn() async {
    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    User? firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    //Signed in
    if (firebaseUser != null) {
      // is already signup?
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      // save user's data
      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'name': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'about': "I'm using Simple Chat",
          'createAt': Timestamp.now(),
          'chattingWidth': null,
        });
        //writing to local
        currentUser = firebaseUser;
        await preferences.setString('id', currentUser.uid);
        await preferences.setString('name', currentUser.displayName.toString());
        await preferences.setString(
            'photoUrl', currentUser.photoURL.toString());
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return new HomeScreen(currentUserId: firebaseUser.uid);
            },
          ),
        );
      }
      //do not save
      else {
        await preferences.setString('id', documentSnapshots[0]['id']);
        await preferences.setString('name', documentSnapshots[0]['name']);
        await preferences.setString(
            'photoUrl', documentSnapshots[0]['photoUrl']);
        await preferences.setString('about', documentSnapshots[0]['about']);
      }
      showSnack('Signed In');
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return new HomeScreen(currentUserId: firebaseUser.uid);
          },
        ),
      );
      this.setState(() {
        isLoading = false;
      });
    } //Failed to signIn
    else {
      showSnack('Try again, Sign in is failed');
      this.setState(() {
        isLoading = false;
      });
    }
  }

  showSnack(var message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

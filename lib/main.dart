import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplechat/constants.dart';
import 'package:simplechat/screens/chat_screen.dart';
import 'package:simplechat/screens/home_screen.dart';
import 'package:simplechat/screens/login_screen.dart';
import 'package:simplechat/screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor.colorPrimary1,
        accentColor: AppColor.colorPrimary2,
      ),
      title: 'Simple Chat',
      // initialRoute: LoginScreen.id,
      // routes: {
      //   LoginScreen.id: (context) => LoginScreen(),
      //   // ChatScreen.id: (context) => ChatScreen(),
      //   SettingsScreen.id: (context) => SettingsScreen(),
      //   // HomeScreen.id: (context) => HomeScreen(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: AssetImage('images/logo.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Simple Chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CuteFont',
                  fontSize: 50.0,
                  color: Colors.orangeAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

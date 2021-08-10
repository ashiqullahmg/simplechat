import 'package:flutter/material.dart';
import 'package:simplechat/constants.dart';
import 'package:simplechat/screens/chat_screen.dart';
import 'package:simplechat/screens/home_screen.dart';
import 'package:simplechat/screens/login_screen.dart';
import 'package:simplechat/screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';

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
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Chat'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Colors.white60,
                Theme.of(context).primaryColor,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      // body: Image(
      //   image: AssetImage('images/emoji_2/pretttygirl(7).gif'),
      // ),
    );
  }
}

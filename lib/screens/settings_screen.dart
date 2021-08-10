import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simplechat/components/alertDialogSettings.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController nameTextEditingController;
  late TextEditingController aboutTextEditingController;
  late SharedPreferences preferences;
  String id = "";
  String name = "";
  String about = "";
  String photoUrl = "";
  File? image;
  File? newImage;
  String newName = "";
  String newAbout = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Avatar
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Center(
                  child: Stack(
                    children: [
                      (image == null)
                          ? (photoUrl != '')
                              ? Material(
                                  // show uploaded image file
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.lightBlueAccent),
                                      ),
                                      width: 160.0,
                                      height: 160.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 160.0,
                                    height: 160.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(125.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 160.0,
                                  color: Colors.grey,
                                )
                          : Material(
                              // show new selected image file
                              child: Image.file(
                                image!,
                                width: 160.0,
                                height: 160.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(125.0),
                              ),
                            ),
                      Positioned(
                          bottom: 0,
                          right: -15,
                          child: RawMaterialButton(
                            onPressed: () {
                              getImage();
                            },
                            elevation: 2.0,
                            fillColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.grey,
                          )),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogSettings(
                              title: 'Enter your name',
                              length: 25,
                              onPressed: () {
                                this.setState(() {
                                  name = nameTextEditingController.text;
                                  Navigator.of(context).pop();
                                });
                              },
                              controller: nameTextEditingController,
                            );
                          });
                    },
                    child: Card(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.white60,
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.white60,
                                fontFamily: 'Source Sans Pro',
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.edit,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogSettings(
                              title: 'Enter your bio',
                              length: 30,
                              onPressed: () {
                                this.setState(() {
                                  about = aboutTextEditingController.text;
                                  Navigator.of(context).pop();
                                });
                              },
                              controller: aboutTextEditingController,
                            );
                          });
                    },
                    child: Card(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.person_pin_outlined,
                          color: Colors.white60,
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bio',
                              style: TextStyle(
                                color: Colors.white60,
                                fontFamily: 'Source Sans Pro',
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              about,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.edit,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Roboto-Medium',
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id').toString();
    name = preferences.getString('name').toString();
    about = preferences.getString('about').toString();
    photoUrl = preferences.getString('photoUrl').toString();
    nameTextEditingController = TextEditingController(text: name);
    aboutTextEditingController = TextEditingController(text: about);
    setState(() {});
  }

  Future getImage() async {
    newImage =
        (await ImagePicker().pickImage(source: ImageSource.gallery)) as File;

    if (newImage != null) {
      this.setState(() {
        this.image = newImage;
        isLoading = true;
      });
    }
    uploadImage();
  }

  Future uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    // Reference ref = storage.ref().child();
  }
}

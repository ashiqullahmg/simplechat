import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simplechat/components/alertDialogSettings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplechat/constants.dart';
import 'package:simplechat/utilities/capitilization.dart';
import 'package:image_cropper/image_cropper.dart';
import '../main.dart';

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
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.logout,
              color: Colors.redAccent,
              size: 30.0,
            ),
            label: Text(''),
            onPressed: () {
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
        ],
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
                              color: Colors.transparent,
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundImage: Image.file(
                                  image!,
                                ).image,
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
                                  name = nameTextEditingController
                                      .text.capitalizeFirstofEach;
                                  Navigator.of(context).pop();
                                });
                                uploadData('name');
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
                                  print(about);
                                  Navigator.of(context).pop();
                                });
                                uploadData('about');
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
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // cropping starts here

    File? croppedFile = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: xFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop your photo',
          toolbarColor: AppColor.colorPrimary1,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropFrameStrokeWidth: 5,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop your photo',
        ));

    // cropping ends here
    newImage = croppedFile;
    if (newImage != null) {
      this.setState(() {
        this.image = newImage;
        isLoading = true;
      });
    }
    uploadImage();
  }

  Future uploadImage() async {
    String mFileName = id;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(mFileName);
    UploadTask uploadTask = ref.putFile(image!);
    uploadTask.then((value) {
      value.ref.getDownloadURL().then((newUrl) {
        photoUrl = newUrl;
        FirebaseFirestore.instance.collection('users').doc(id).update({
          'photoUrl': photoUrl,
        }).then((data) async {
          await preferences.setString('photoUrl', photoUrl);
          setState(() {
            isLoading = false;
          });
          showSnack("Photo updated successfully.");
        });
      }, onError: (errorMessage) {
        showSnack(errorMessage.toString());
        setState(() {
          isLoading = false;
        });
      });
    }, onError: (errorMessage) {
      setState(() {
        isLoading = false;
      });
      showSnack(errorMessage.toString());
    });
  }

  Future uploadData(String value) async {
    FirebaseFirestore.instance.collection('users').doc(id).update({
      '$value': value == 'name' ? name : about,
    }).then((data) async {
      await preferences.setString(value, value == 'name' ? name : about);
      setState(() {
        isLoading = false;
      });
      showSnack("${value == 'name' ? 'Name' : 'Bio'} updated successfully.");
    });
  }

  showSnack(var message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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

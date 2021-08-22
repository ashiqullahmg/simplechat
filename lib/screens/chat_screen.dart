
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simplechat/components/emojiRow.dart';
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
import 'package:simplechat/components/showSnack.dart';
import 'package:simplechat/constants.dart';
import 'package:simplechat/utilities/capitilization.dart';
import 'package:image_cropper/image_cropper.dart';
import '../main.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String receiverName;
  final String receiverId;
  final String receiverAvatar;
  const ChatScreen(
      {Key? key,
      required this.receiverName,
      required this.receiverId,
      required this.receiverAvatar})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageEditingController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  bool isStickers = false;
  bool isLoading = false;
  late File? image;
  late String imageUrl;
  @override
  void initState(){
    super.initState();
    messageFocusNode.addListener(onFocusChange);
  }
  onFocusChange() {
    setState(() {
      isStickers = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  CachedNetworkImageProvider(widget.receiverAvatar),
            ),
            SizedBox(
              width: 6.0,
            ),
            Text(
              widget.receiverName,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: [
          messagesStream(),

          //Stickers

          // Input Controllers
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              children: [
                // Image Picker Button
                IconButton(
                  onPressed: getImage,
                  icon: Icon(Icons.photo,
                  color: Colors.white,),
                ),
                //TextField for text writing
                Flexible(
                  child: TextFormField(
                    maxLines: null,
                    controller: messageEditingController,
                    focusNode: messageFocusNode,
                    // controller: messageTextController,
                    onChanged: (value) {
                      // messageText = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                // Icon Picker Button
                IconButton(
                  hoverColor: Colors.red,
                  onPressed: () {
                    setState(() {
                      if(!isStickers) {
                        isStickers = true;
                      } else{
                        isStickers = false;
                      }
                    });
                  },
                  icon: Icon(Icons.emoji_emotions_outlined,
                  color: Colors.white,),
                ),
                //Send Message Button
                IconButton(
                  onPressed: (){
                    sendMessage(messageEditingController.text, 0);
                  },
                  icon: Icon(Icons.send,
                  color: Colors.white,),
                ),
              ],
            ),
          ),
          (isStickers ? displayStickers() : Container()),
        ],
      ),
    );
  }

  messagesStream() {
    return Expanded(child: CircularProgressIndicator());
  }

  displayStickers() {
    return Container(
      height: 200.0,
      child: SingleChildScrollView(
        child: Column(
    children: [
      SizedBox(height: 5.0,),
      Text('Pretty Girl'),
      EmojiRow(location: 'emoji_2', emoji1: 'prettygirl_1.gif', emoji2: 'prettygirl_2.gif', emoji3: 'prettygirl_3.gif', onPressed1: (){sendMessage('prettygirl_1', 2);}, onPressed2: (){sendMessage('prettygirl_2', 2);}, onPressed3:(){sendMessage('prettygirl_3', 2);}),
      EmojiRow(location: 'emoji_2', emoji1: 'prettygirl_4.gif', emoji2: 'prettygirl_5.gif', emoji3: 'prettygirl_6.gif', onPressed1: (){sendMessage('prettygirl_4', 2);}, onPressed2: (){sendMessage('prettygirl_5', 2);}, onPressed3:(){sendMessage('prettygirl_6', 2);}),
      EmojiRow(location: 'emoji_2', emoji1: 'prettygirl_7.gif', emoji2: 'prettygirl_8.gif', emoji3: 'prettygirl_9.gif', onPressed1: (){sendMessage('prettygirl_7', 2);}, onPressed2: (){sendMessage('prettygirl_8', 2);}, onPressed3:(){sendMessage('prettygirl_9', 2);}),
      EmojiRow(location: 'emoji_2', emoji1: 'prettygirl_10.gif', emoji2: 'prettygirl_11.gif', emoji3: 'prettygirl_12.gif', onPressed1: (){sendMessage('prettygirl_10', 2);}, onPressed2: (){sendMessage('prettygirl_11', 2);}, onPressed3:(){sendMessage('prettygirl_12', 2);}),
      EmojiRow(location: 'emoji_2', emoji1: 'prettygirl_13.gif', emoji2: 'prettygirl_14.gif', emoji3: 'prettygirl_15.gif', onPressed1: (){sendMessage('prettygirl_13', 2);}, onPressed2: (){sendMessage('prettygirl_14', 2);}, onPressed3:(){sendMessage('prettygirl_15', 2);}),
      SizedBox(height: 5.0,),
      Text('Faces'),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_1.gif', emoji2: 'emoji_2.gif', emoji3: 'emoji_3.gif', onPressed1: (){sendMessage('emoji_1', 2);}, onPressed2: (){sendMessage('emoji_2', 2);}, onPressed3: (){sendMessage('emoji_3', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_4.gif', emoji2: 'emoji_5.gif', emoji3: 'emoji_6.gif', onPressed1: (){sendMessage('emoji_4', 2);}, onPressed2: (){sendMessage('emoji_5', 2);}, onPressed3: (){sendMessage('emoji_6', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_7.gif', emoji2: 'emoji_8.gif', emoji3: 'emoji_9.gif', onPressed1: (){sendMessage('emoji_7', 2);}, onPressed2: (){sendMessage('emoji_8', 2);}, onPressed3: (){sendMessage('emoji_9', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_10.gif', emoji2: 'emoji_11.gif', emoji3: 'emoji_12.gif', onPressed1: (){sendMessage('emoji_10', 2);}, onPressed2: (){sendMessage('emoji_11', 2);}, onPressed3: (){sendMessage('emoji_12', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_13.gif', emoji2: 'emoji_14.gif', emoji3: 'emoji_15.gif', onPressed1: (){sendMessage('emoji_13', 2);}, onPressed2: (){sendMessage('emoji_14', 2);}, onPressed3: (){sendMessage('emoji_15', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_16.gif', emoji2: 'emoji_17.gif', emoji3: 'emoji_18.gif', onPressed1: (){sendMessage('emoji_16', 2);}, onPressed2: (){sendMessage('emoji_17', 2);}, onPressed3: (){sendMessage('emoji_18', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_19.gif', emoji2: 'emoji_20.gif', emoji3: 'emoji_21.gif', onPressed1: (){sendMessage('emoji_19', 2);}, onPressed2: (){sendMessage('emoji_20', 2);}, onPressed3: (){sendMessage('emoji_21', 2);}),
      EmojiRow(location: 'emoji_1', emoji1: 'emoji_22.gif', emoji2: 'emoji_23.gif', emoji3: 'emoji_24.gif', onPressed1: (){sendMessage('emoji_22', 2);}, onPressed2: (){sendMessage('emoji_23', 2);}, onPressed3: (){sendMessage('emoji_24', 2);}),
    ],
        ),
      ),
    );
  }

  Future getImage() async{
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(xFile!.path);

    if(image != null){
      isLoading = true;
    }
    uploadImage();
  }

  Future uploadImage() async{
    String fileName = '${DateTime.now().millisecondsSinceEpoch}'+widget.receiverId;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('Chat Images').child(fileName);
    UploadTask uploadTask = ref.putFile(image!);
    uploadTask.then((value) {
      value.ref.getDownloadURL().then((newUrl) {
        imageUrl = newUrl;
        setState(() {
          isLoading = false;
          sendMessage(imageUrl, 1);
        });
          showSnack('Uploaded', context);
      }, onError: (errorMessage) {
        showSnack(errorMessage.toString(), context);
        setState(() {
          isLoading = false;
        });
      });
    }, onError: (errorMessage) {
      setState(() {
        isLoading = false;
      });
      showSnack(errorMessage.toString(),context);
    });



  }

  sendMessage(String text, int type) {
    // 0 for message
    // 1 for image
    // 2 for emoji
    showSnack(text+type.toString(), context);
    print('$text'+'$type');
  }


}

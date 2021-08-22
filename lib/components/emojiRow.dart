import 'package:flutter/material.dart';

class EmojiRow extends StatelessWidget {
  EmojiRow({required this.location, required this.emoji1,required this.emoji2, required this.emoji3, required this.onPressed1, required this.onPressed2, required this.onPressed3});
  final VoidCallback onPressed1, onPressed2, onPressed3;
  final String location, emoji1, emoji2, emoji3;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: onPressed1, child: Image.asset('images/$location/$emoji1', width: 100.0, height: 100.0, ),),
        TextButton(onPressed: onPressed2, child: Image.asset('images/$location/$emoji2', width: 100.0, height: 100.0, fit: BoxFit.cover,),),
        TextButton(onPressed: onPressed3, child: Image.asset('images/$location/$emoji3', width: 100.0, height: 100.0, fit: BoxFit.cover,),),
      ],
    );
  }
}
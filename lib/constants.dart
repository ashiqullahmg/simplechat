import 'package:flutter/material.dart';

class AppColor {
  // static Color colorPrimary1 = Colors.green;
  // static Color colorPrimary2 = Colors.grey;
  static final Color colorPrimary1 = Color.fromRGBO(30, 81, 126, 1.0);
  static final Color colorPrimary2 = Color.fromRGBO(28, 117, 149, 1.0);
  static final Color accentColor = Color.fromRGBO(28, 117, 149, 1.0);
}

const kTextFieldDecoration = InputDecoration(
  labelText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

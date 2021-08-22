import 'package:flutter/material.dart';
showSnack(var message, var context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
}
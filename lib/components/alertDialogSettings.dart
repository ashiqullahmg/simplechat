import 'dart:ffi';

import 'package:flutter/material.dart';

class AlertDialogSettings extends StatelessWidget {
  const AlertDialogSettings({
    Key? key,
    required this.title,
    required this.length,
    required this.onPressed,
    required this.controller,
  }) : super(key: key);
  final String title;
  final int length;
  final VoidCallback onPressed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.cyan,
      insetPadding: EdgeInsets.all(0),
      title: Text(
        title,
        style: TextStyle(fontSize: 15.0),
      ),
      content: Builder(
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width - 0,
            // key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    controller: controller,
                    onChanged: (value) {
                      controller.text = value;
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
                    },
                    maxLength: length,
                    maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: TextButton(
                        child: Text("Cancel"),
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
                        child: Text("Submit"),
                        onPressed: onPressed,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

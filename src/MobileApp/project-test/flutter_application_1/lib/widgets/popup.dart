import 'package:flutter/material.dart';

void showPopup(BuildContext context, String buttonText, String popupText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Popup'),
        content: Text(popupText),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
          ),
        ],
      );
    },
  );
}

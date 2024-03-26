import 'package:flutter/material.dart';

class TextPopupButton extends StatelessWidget {
  final String buttonText;
  final String popupText;

  TextPopupButton({required this.buttonText, required this.popupText});

  void _showPopup(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showPopup(context),
      child: Text(buttonText),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void showPopup(BuildContext context, String buttonText, String popupText) {
  TextEditingController textEditingController = TextEditingController(text: popupText);
  final TextEditingController _endpointController = TextEditingController(text: "http://${dotenv.env['CURRENT_IP']}:8000/uploadReceiptData/");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Popup'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Use as little space as needed
          children: [
            Expanded(
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter text here',
                  border: OutlineInputBorder(), // Adds a border around the TextField
                ),
                maxLines: null, // Allows for unlimited lines
                minLines: 5,  // Sets a minimum size for the text field
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              // Handle the edited text
              String editedText = textEditingController.text;
              // For example, print the edited text
              print(editedText);
              String endpoint = _endpointController.text; 
              Map<String, dynamic> body = {'text': editedText};
              sendData(endpoint, body);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
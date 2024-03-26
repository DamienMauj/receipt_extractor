import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressCallback;

  CustomButton({required this.buttonText, required this.onPressCallback});

  @override
  Widget build(BuildContext context) {
    print("CustomButton build");
    return ElevatedButton(
      onPressed: onPressCallback,
      child: Text(buttonText),
    );
  }
}

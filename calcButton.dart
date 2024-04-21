import 'package:flutter/material.dart';

Widget calcButton(
    String buttonText, Color buttonColor, void Function()? buttonPressed) {
  return Container(
    width: 75,
    height: buttonText == '=' ? 150 : 70,
    padding: const EdgeInsets.all(0),
    child: ElevatedButton(
        onPressed: buttonPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white60,
            foregroundColor: Colors.pink,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        child: Text(buttonText,
            style: const TextStyle(fontSize: 27, color: Colors.black))),
  );

//here calcButton is basically a helper function that returns a widget that represents a button on the calculator
}

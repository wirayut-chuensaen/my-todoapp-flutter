import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  primaryColor: Colors.blue,
  canvasColor: Colors.white,
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: const TextStyle(
            color: Color.fromRGBO(51, 51, 51, 1), fontFamily: "Prompt"),
      ),
  hintColor: Colors.black26,
);

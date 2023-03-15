import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  primaryColor: Colors.blue,
  canvasColor: Colors.white,
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyLarge: const TextStyle(color: Colors.black, fontFamily: "MN_BURI"),
      ),
  hintColor: Colors.black26,
);

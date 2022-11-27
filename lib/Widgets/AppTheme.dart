import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  primaryColor: Colors.blue,
  canvasColor: Colors.white,
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: const TextStyle(color: Color.fromRGBO(51, 51, 51, 1)),
      ),
  // appBarTheme: AppBarTheme(color: Color.fromRGBO(215, 105, 212, 1)),
  hintColor: Colors.black26,
  // colorScheme: ColorScheme.fromSwatch()
  //     .copyWith(secondary: const Color.fromRGBO(0, 158, 32, 1)),
);

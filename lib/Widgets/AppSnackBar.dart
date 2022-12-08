import 'package:flutter/material.dart';
import 'package:todo_app/Widgets/AppText.dart';

void snackbar(String text, BuildContext context) {
  final snackBar = SnackBar(
    content: AppText(
      text: text,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: Theme.of(context).primaryColor,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

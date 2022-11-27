// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function? onSubmit;
  final String? text;
  final double borderRadius;

  AppButton({
    super.key,
    this.onSubmit,
    this.text,
    this.borderRadius = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSubmit as void Function()?,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text!,
          style: const TextStyle(color: Colors.white, fontFamily: "Prompt"),
        ),
      ),
    );
  }
}

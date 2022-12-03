import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;

  const AppText({
    super.key,
    required this.text,
    this.size = 14,
    this.fontWeight = FontWeight.normal,
    this.color = const Color.fromRGBO(51, 51, 51, 1),
    this.fontStyle = FontStyle.normal,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        softWrap: true,
        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontFamily: "Prompt",
        ));
  }
}

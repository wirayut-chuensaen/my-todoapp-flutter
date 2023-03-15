import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final TextAlign textAlign;

  const AppText({
    super.key,
    required this.text,
    this.size = 16,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.fontStyle = FontStyle.normal,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        softWrap: true,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontFamily: "MN_BURI",
        ));
  }
}

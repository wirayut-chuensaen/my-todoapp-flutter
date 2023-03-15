// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? text;
  final String hintText;
  final IconData? leftIcon;
  final TextInputType? inputType;
  final ValueChanged? onChanged;
  final int maxLength;
  final int maxLines;
  final double fontSize;
  bool obscureText;
  bool editable;

  AppTextField({
    super.key,
    this.text,
    this.hintText = '',
    this.leftIcon,
    this.inputType,
    this.obscureText = false,
    this.onChanged,
    this.maxLines = 1,
    this.fontSize = 16,
    this.maxLength = 0,
    this.editable = true,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50 * double.parse(widget.maxLines.toString()),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: TextField(
        autofocus: false,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontFamily: "MN_BURI",
        ),
        enabled: widget.editable,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          counterText: "",
          hintText: widget.hintText,
          filled: true,
          fillColor: widget.editable
              ? Colors.white
              : const Color.fromRGBO(232, 232, 232, 1),
          prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon) : null,
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        controller: widget.text,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        maxLength:
            widget.maxLength == 0 ? TextField.noMaxLength : widget.maxLength,
      ),
    );
  }
}

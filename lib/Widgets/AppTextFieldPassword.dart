// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppTextFieldPassword extends StatefulWidget {
  final TextEditingController? text;
  final String? hintText;
  final IconData? leftIcon;
  final ValueChanged? onChanged;

  const AppTextFieldPassword({
    super.key,
    this.text,
    this.hintText = "",
    this.leftIcon,
    this.onChanged,
  });

  @override
  _AppTextFieldPasswordState createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  bool obscureText = true;

  void _toggleShowPassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Widget buildIconVisible() {
    if (obscureText == false) {
      return IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: const Icon(
          Icons.visibility_outlined,
          color: Color.fromRGBO(232, 232, 232, 1),
          size: 22.0,
        ),
        onPressed: () => _toggleShowPassword(),
      );
    } else {
      return IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: const Icon(
          Icons.visibility_off_outlined,
          color: Color.fromRGBO(232, 232, 232, 1),
          size: 22.0,
        ),
        onPressed: () => _toggleShowPassword(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        style: const TextStyle(
          fontFamily: "Prompt",
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon) : null,
          suffixIcon: buildIconVisible(),
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(232, 232, 232, 1)),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        obscureText: obscureText,
        controller: widget.text,
        onChanged: widget.onChanged,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;

  const AppBarCustom({Key? key, this.title, this.showBack = false})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.showBack,
      iconTheme: const IconThemeData(color: Colors.black87),
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "${widget.title}",
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontFamily: "Prompt"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/Widgets/AppText.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool isMain;
  final Function? onPress;

  const AppBarCustom({
    Key? key,
    this.title = "",
    this.isMain = false,
    this.onPress,
  })  : preferredSize = const Size.fromHeight(80),
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
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.cyan,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: widget.onPress as void Function()?,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      widget.isMain ? Icons.menu : Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.blue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: AppText(
                      text: widget.title.toString(),
                      color: Colors.white,
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

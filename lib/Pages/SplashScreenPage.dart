// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Pages/LoginPage.dart';
import 'package:todo_app/Pages/MainPage.dart';
import 'package:todo_app/Widgets/AppText.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    Timer(const Duration(seconds: 1), () async {
      var prefs = await SharedPreferences.getInstance();
      bool? loginStatus = prefs.getBool("loginStatus");
      // print("login status : $loginStatus");
      if (loginStatus != null && loginStatus == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const MainPage())));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const LoginPage())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          Column(
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: MediaQuery.of(context).size.width * 0.4,
                color: Theme.of(context).primaryColor,
              ),
              AppText(
                text: "My Simple Todo App",
                color: Theme.of(context).primaryColor,
                size: 30,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          AppText(
            text: "By Wirayut Chuensaen",
            color: Theme.of(context).primaryColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}

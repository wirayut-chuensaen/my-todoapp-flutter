// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Pages/LoginPage.dart';
import 'package:todo_app/Pages/MainPage.dart';

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
      padding: const EdgeInsets.only(top: kToolbarHeight),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Image.asset(
          "assets/splash.jpg",
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}

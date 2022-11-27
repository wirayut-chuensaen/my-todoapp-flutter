import 'dart:async';

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

  void checkLogin() {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const LoginPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: const Center(
        child: AppText(
          text: "My Simple Todo App",
          color: Colors.white,
          size: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

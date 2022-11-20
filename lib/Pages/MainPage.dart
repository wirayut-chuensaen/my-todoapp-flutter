import 'package:flutter/material.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: "Main"),
      body: Container(),
    );
  }
}

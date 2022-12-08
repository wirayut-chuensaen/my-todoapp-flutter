import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/Pages/AddEditTodoPage.dart';
import 'package:todo_app/Pages/LoginPage.dart';
import 'package:todo_app/Pages/MainPage.dart';
import 'package:todo_app/Pages/SplashScreenPage.dart';
import 'package:todo_app/Widgets/AppTheme.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          // currentFocus.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'My Simple Todo App',
        theme: themeData,
        builder: EasyLoading.init(),
        home: const SplashScreenPage(),
        routes: {
          "/splash": (context) => const SplashScreenPage(),
          "/login": (context) => const LoginPage(),
          "/main": (context) => const MainPage(),
          "/add_todo": (context) => const AddEditTodoPage(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/Pages/AddEditTodoPage.dart';
import 'package:todo_app/src/Pages/LoginPage.dart';
import 'package:todo_app/src/Pages/MainPage.dart';
import 'package:todo_app/src/Pages/SplashScreenPage.dart';
import 'package:todo_app/src/Widgets/AppTheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/src/bloc/authenticate/authenticate_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticateCubit()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          title: 'My Todo App',
          theme: themeData,
          builder: EasyLoading.init(),
          home: const SplashScreenPage(),
          routes: {
            "/splash": (context) => const SplashScreenPage(),
            "/login": (context) => const LoginPage(),
            "/main": (context) => const MainPage(),
            "/add_edit_todo": (context) => const AddEditTodoPage(),
          },
        ),
      ),
    );
  }
}

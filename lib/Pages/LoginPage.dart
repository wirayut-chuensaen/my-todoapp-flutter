import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/Pages/MainPage.dart';
import 'package:todo_app/Pages/RegisterPage.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppButton.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/authService.dart';
import '../Widgets/AppText.dart';
import '../Widgets/AppTextField.dart';
import '../Widgets/AppTextFieldPassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String _email = "";
  String _password = "";
  bool isRegistered = false;
  bool loginStatus = false;

  @override
  void initState() {
    super.initState();
  }

  void onValidateForm() {
    if (_email.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Please enter your email.",
      );
    } else if (_password.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Please enter your password.",
      );
    } else {
      onLogin();
    }
  }

  void onLogin() async {
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.show(status: 'Loading...');
    loginStatus =
        await AuthService.loginWithEmailAndPassword(context, _email, _password);
    if (loginStatus) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setBool("loginStatus", true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const MainPage())));
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: "Login"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const AppText(text: "Email"),
            AppTextField(
              text: email,
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const AppText(text: "Password"),
            AppTextFieldPassword(
              text: password,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Login',
              borderRadius: 50.0,
              onSubmit: () => onValidateForm(),
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(child: Divider(color: Colors.black38, height: 5)),
                Padding(
                    padding: EdgeInsets.all(10), child: AppText(text: "Or")),
                Expanded(child: Divider(color: Colors.black38, height: 5)),
              ],
            ),
            const SizedBox(height: 5),
            AppButton(
              text: 'Signup',
              borderRadius: 50.0,
              onSubmit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const RegisterPage()))),
            ),
          ],
        ),
      ),
    );
  }
}

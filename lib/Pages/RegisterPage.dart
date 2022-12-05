import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppButton.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../Services/AuthService.dart';
import '../Widgets/AppText.dart';
import '../Widgets/AppTextField.dart';
import '../Widgets/AppTextFieldPassword.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  String _name = "";
  String _email = "";
  String _password = "";
  String _passwordConfirm = "";
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
  }

  void onValidateForm() {
    if (_name.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Please enter your name.",
      );
    } else if (_email.isEmpty) {
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
    } else if (_passwordConfirm.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Please enter your confirm password.",
      );
    } else if (_password != _passwordConfirm) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Password and confirm password do not match.",
      );
    } else {
      onSignup();
    }
  }

  void onSignup() async {
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.show(status: 'Loading...');
    isRegistered = await AuthService.registerWithEmailAndPassword(
        context, _name, _email, _password);
    if (isRegistered) {
      clearData();
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          barrierDismissible: false,
          text: 'Signup success!\nPlease login',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
    }
    EasyLoading.dismiss();
  }

  void clearData() {
    _email = "";
    _password = "";
    _passwordConfirm = "";
    email.text = "";
    password.text = "";
    passwordConfirm.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: "Signup",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const AppText(text: "Name"),
            AppTextField(
              text: name,
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
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
            const AppText(text: "Confirm Password"),
            AppTextFieldPassword(
              text: passwordConfirm,
              onChanged: (value) {
                setState(() {
                  _passwordConfirm = value;
                });
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Sign up',
              borderRadius: 50.0,
              onSubmit: () => onValidateForm(),
            ),
          ],
        ),
      ),
    );
  }
}

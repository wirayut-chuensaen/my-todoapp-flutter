// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppButton.dart';
import '../Services/AuthService.dart';
import '../Widgets/AppDialog.dart';
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
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Please enter your name.",
        ),
      );
    } else if (_email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Please enter your email.",
        ),
      );
    } else if (_password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Please enter your password.",
        ),
      );
    } else if (_passwordConfirm.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Please enter your confirm password.",
        ),
      );
    } else if (_password != _passwordConfirm) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Password and confirm password do not match.",
        ),
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.check,
          onPopScope: false,
          dialogTitle: "Signup success!",
          dialogDescription: "Please login",
          onConfirmBtnPress: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
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
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kToolbarHeight * 0.4),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.blue,
                  size: 40,
                ),
                onPressed: () => Navigator.pop(context),
                label: const AppText(text: ""),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(0.0)),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        color: Colors.grey.shade100,
                        spreadRadius: 4,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/register_image.jpg",
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
      ),
    );
  }
}

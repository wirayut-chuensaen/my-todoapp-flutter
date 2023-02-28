import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/Pages/MainPage.dart';
import 'package:todo_app/Pages/RegisterPage.dart';
import 'package:todo_app/Widgets/AppButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Widgets/AppDialog.dart';
import '../Services/AuthService.dart';
import '../Widgets/AppText.dart';
import '../Widgets/AppTextField.dart';
import '../Widgets/AppTextFieldPassword.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  String versionNumber = "";

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light;
    initVersionNumber();
  }

  void initVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      versionNumber = 'Version $version ($buildNumber)';
    });
  }

  void onValidateForm() {
    if (_email.isEmpty) {
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
    } else {
      onLogin();
    }
  }

  void onLogin() async {
    EasyLoading.show(status: 'Loading...');
    loginStatus =
        await AuthService.loginWithEmailAndPassword(context, _email, _password);
    if (loginStatus) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setBool("loginStatus", true).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const MainPage())));
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(15, kToolbarHeight, 15, 0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
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
                            "assets/login_image.jpg",
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width * 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                      Expanded(
                          child: Divider(color: Colors.black38, height: 5)),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: AppText(text: "Or")),
                      Expanded(
                          child: Divider(color: Colors.black38, height: 5)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  AppButton(
                    text: 'Sign up',
                    borderRadius: 50.0,
                    onSubmit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const RegisterPage()))),
                  ),
                ],
              ),
              Center(
                child: AppText(
                  text: versionNumber,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

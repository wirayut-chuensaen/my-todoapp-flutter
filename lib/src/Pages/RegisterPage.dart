import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/src/Widgets/AppButton.dart';
import 'package:todo_app/src/bloc/authenticate/authenticate_cubit.dart';
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
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
  }

  void onValidateForm(
      String name, String email, String password, String confirmPassword) {
    String errorMessage = "";
    if (name.isEmpty) {
      errorMessage = "Please enter your name.";
    } else if (email.isEmpty) {
      errorMessage = "Please enter your email.";
    } else if (password.isEmpty) {
      errorMessage = "Please enter your password.";
    } else if (confirmPassword.isEmpty) {
      errorMessage = "Please enter your confirm password.";
    } else if (password != confirmPassword) {
      errorMessage = "Password and confirm password do not match.";
    }
    if (errorMessage.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: errorMessage,
        ),
      );
    } else {
      context.read<AuthenticateCubit>().onSignUpAction(context).then((value) {
        _name.text = "";
        _email.text = "";
        _password.text = "";
        _passwordConfirm.text = "";
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticateCubit, AuthenticateState>(
        builder: (context, state) {
          return SingleChildScrollView(
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
                      text: _name,
                      onChanged: (value) => context
                          .read<AuthenticateCubit>()
                          .onNameChanged(value)),
                  const SizedBox(height: 10),
                  const AppText(text: "Email"),
                  AppTextField(
                    text: _email,
                    onChanged: (value) =>
                        context.read<AuthenticateCubit>().onEmailChanged(value),
                  ),
                  const SizedBox(height: 10),
                  const AppText(text: "Password"),
                  AppTextFieldPassword(
                      text: _password,
                      onChanged: (value) => context
                          .read<AuthenticateCubit>()
                          .onPasswordChanged(value)),
                  const SizedBox(height: 10),
                  const AppText(text: "Confirm Password"),
                  AppTextFieldPassword(
                    text: _passwordConfirm,
                    onChanged: (value) => context
                        .read<AuthenticateCubit>()
                        .onConfirmPassowrdChanged(value),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'Sign up',
                    borderRadius: 50.0,
                    onSubmit: () => onValidateForm(state.name, state.email,
                        state.password, state.confirmPassword),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

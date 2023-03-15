import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Pages/LoginPage.dart';
import '../../Pages/MainPage.dart';
import '../../Services/AuthService.dart';

part 'authenticate_state.dart';

class AuthenticateCubit extends Cubit<AuthenticateState> {
  AuthenticateCubit() : super(AuthenticateState());

  void onNameChanged(String value) => emit(state.copyWith(name: value));
  void onEmailChanged(String value) => emit(state.copyWith(email: value));
  void onPasswordChanged(String value) => emit(state.copyWith(password: value));
  void onConfirmPassowrdChanged(String value) =>
      emit(state.copyWith(confirmPassword: value));

  void onResetState() => emit(state.copyWith(
        name: "",
        email: "",
        password: "",
        confirmPassword: "",
      ));

  Future<void> onLoginAction(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    bool loginStatus = await AuthService.loginWithEmailAndPassword(
        context, state.email, state.password);
    if (loginStatus) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setBool("loginStatus", true).then((value) {
        onResetState();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const MainPage())));
      });
    }
    EasyLoading.dismiss();
  }

  Future<bool> onSignUpAction(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    bool isRegistered = await AuthService.registerWithEmailAndPassword(
        context, state.name, state.email, state.password);
    if (isRegistered) {
      onResetState();
    }
    EasyLoading.dismiss();
    return isRegistered;
  }

  Future<void> onLogoutAction(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await AuthService.logout().then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  Future<bool> onResetPasswordAction(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    bool isReseted = await AuthService.resetPassword(context, state.email);
    if (isReseted) {
      onResetState();
    }
    EasyLoading.dismiss();
    return isReseted;
  }
}

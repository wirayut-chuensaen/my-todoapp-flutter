import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;
  static User user = auth.currentUser!;

  // Sign-in process
  static Future<bool> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      // print("loginWithEmailAndPassword error : $error");
      if (error.code == 'invalid-email' || error.code == 'wrong-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "The username or password is invalid.",
        );
      } else if (error.code == 'user-not-found') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "The user not found.",
        );
      }
      return false;
    } catch (error) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "Something went wrong.",
      );
      return false;
    }
  }

  // Sign-up process
  static Future<bool> registerWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      // print("registerWithEmailAndPassword error : $error");
      if (error.code == 'weak-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "The password provided is too weak.",
        );
      } else if (error.code == 'email-already-in-use') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "Entered email already in use.",
        );
      } else if (error.code == 'invalid-email') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "Invalid email.",
        );
      }
      return false;
    } catch (error) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "Something went wrong.",
      );
      return false;
    }
  }

  static Future<void> logout() async {
    return auth.signOut();
  }
}

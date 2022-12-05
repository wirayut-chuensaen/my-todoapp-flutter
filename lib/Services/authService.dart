import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;
  static User user = auth.currentUser!;

  // Login process
  static Future<bool> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
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
      BuildContext context, String name, String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.currentUser!.updateDisplayName(name);
      return true;
    } on FirebaseAuthException catch (error) {
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

  // Send reset password email to user's email process
  static Future<bool> resetPassword(BuildContext context, String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "Something went wrong.",
      );
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

  // Get user display name
  static String getUserDisplayName() {
    return user.displayName.toString();
  }

  // Get user email
  static String getUserEmail() {
    return user.email.toString();
  }

  // Logout process
  static Future<void> logout() async {
    return auth.signOut();
  }
}

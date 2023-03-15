import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widgets/AppDialog.dart';

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
        showDialog(
          context: context,
          builder: (context) => AppDialog(
            dialogType: DialogType.alert,
            dialogLogo: DialogLogo.cross,
            dialogTitle: "Oops...",
            dialogDescription: "The username or password is invalid.",
          ),
        );
      } else if (error.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) => AppDialog(
            dialogType: DialogType.alert,
            dialogLogo: DialogLogo.cross,
            dialogTitle: "Oops...",
            dialogDescription: "The user not found.",
          ),
        );
      }
      return false;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.cross,
          dialogTitle: "Oops...",
          dialogDescription: "Something went wrong.",
        ),
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
        showDialog(
          context: context,
          builder: (context) => AppDialog(
            dialogType: DialogType.alert,
            dialogLogo: DialogLogo.cross,
            dialogTitle: "Oops...",
            dialogDescription: "The password provided is too weak.",
          ),
        );
      } else if (error.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (context) => AppDialog(
            dialogType: DialogType.alert,
            dialogLogo: DialogLogo.cross,
            dialogTitle: "Oops...",
            dialogDescription: "Entered email already in use.",
          ),
        );
      } else if (error.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (context) => AppDialog(
            dialogType: DialogType.alert,
            dialogLogo: DialogLogo.cross,
            dialogTitle: "Oops...",
            dialogDescription: "Invalid email.",
          ),
        );
      }
      return false;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.cross,
          dialogTitle: "Oops...",
          dialogDescription: "Something went wrong.",
        ),
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
      return false;
    } catch (error) {
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

import 'package:firebase_auth/firebase_auth.dart';

class User {
  User();
  String getID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}

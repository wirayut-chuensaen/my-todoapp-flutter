import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Models/User.dart';
import 'package:todo_app/Services/firebaseService.dart';

class TodoService extends FirebaseService {
  TodoService();

  @override
  CollectionReference getCollectionReference() {
    // print(User().getID());
    return FirebaseService.db
        .collection("users")
        .doc(User().getID())
        .collection("todo");
  }

  @override
  String getID() {
    return getCollectionReference().doc().id;
  }

  Stream<QuerySnapshot> getTodoListOfCurrentUser() {
    return getCollectionReference().snapshots();
  }
}

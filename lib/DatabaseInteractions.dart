import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_approval_flutter/Universals.dart';

class DatabaseInteractions {

  static void getTaSecretCode() {
    FirebaseFirestore.instance
        .collection('ta secret codes')
        .doc("ta secret codes")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        Universals.taSecretCode = documentSnapshot.data()["ta secret code"];
      } else {
        print('Document does not exist on the database');
        Universals.taSecretCode = "";
      }
    });
  }

  static void saveUserProfile(String email) {
    FirebaseFirestore.instance.collection('users')
        .doc(email)
        .set({
      'email': email,
    })
        .then((value) => print("User Profile Added"))
        .catchError((error) => print("Failed to add user profile: $error"));
  }

  static void saveNewRequest(String name, String email, String course, String question) {
    var now = new DateTime.now();
    print(now.add(Duration(hours: -10)));
    var nowHawaii = now.add(Duration(hours: -10));

    FirebaseFirestore.instance.collection("new requests")
        .doc(nowHawaii.toString())
        .set({
      'name': name,
      'email': email,
      'course': course,
      'questions': question,
      'requested time': nowHawaii,
      'status': "new"
    })
        .then((value) => print("New Request Added"))
        .catchError((error) => print("Failed to save new request: $error"));
  }

}
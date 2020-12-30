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

}
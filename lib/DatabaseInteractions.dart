import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_approval_flutter/Request.dart';
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

  static void saveNewRequest(Request request) {
    var now = new DateTime.now();
    print(now.add(Duration(hours: -10)));
    var nowHawaii = now.add(Duration(hours: -10)).toString();

    request.requestedTimeHawaii = nowHawaii;
    request.status = "new";

    FirebaseFirestore.instance.collection("new requests")
        .doc(nowHawaii.toString())
        .set({
      'name': request.name,
      'email': request.email,
      'course': request.course,
      'question': request.question,
      'requested time hawaii': request.requestedTimeHawaii,
      'status': request.status
    })
        .then((value) => print("New Request Added"))
        .catchError((error) => print("Failed to save new request: $error"));
  }

}
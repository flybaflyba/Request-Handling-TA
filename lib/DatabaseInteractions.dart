import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:virtual_approval_flutter/UserInformation.dart';

class DatabaseInteractions {

  static void getTaSecretCode() {
    FirebaseFirestore.instance
        .collection('ta secret codes')
        .doc("ta secret codes")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        UniversalValues.taSecretCode = documentSnapshot.data()["ta secret code"];
      } else {
        print('Document does not exist on the database');
        UniversalValues.taSecretCode = "";
      }
    });
  }

  static void getLoggedInUserInformation(String email) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        UniversalValues.loggedInUserInformation = new UserInformation(
            name: documentSnapshot.data()["name"],
            email: documentSnapshot.data()["email"],
            department: documentSnapshot.data()["department"]);
        // print(UniversalValues.loggedInUserInformation);

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('userName', documentSnapshot.data()["name"]);
        // await prefs.setString('userEmail', documentSnapshot.data()["email"]);
        // await prefs.setString('userDepartment',  documentSnapshot.data()["department"]);
        
      } else {
        print('Document does not exist on the database');
        UniversalValues.loggedInUserInformation = null;
      }
    });
  }


  static void saveUserProfile(UserInformation userInformation) {
    FirebaseFirestore.instance.collection('users')
        .doc(userInformation.email)
        .set({
      "name": userInformation.name,
      'email': userInformation.email,
      "department": userInformation.department,
    })
        .then((value) => print("User Profile Added"))
        .catchError((error) => print("Failed to add user profile: $error"));
  }

  static void sendAEmail() {
    FirebaseFirestore.instance.collection("emails")
        .add({
      "to": ['litianz@byuh.edu', 'masondu@go.byuh.edu', 'litian_zhang17@163.com'],
      "message": {
        "subject": 'Hello from Firebase!',
        "text": 'This is the plaintext section of the email body.',
        "html": 'This is the <code>HTML</code> section of the email body.',
      }
    })
        .then((value) => print("New Email Doc Created"))
        .catchError((error) => print("Failed to create email doc: $error"));
  }

  static void saveRequest(Request request) {
    FirebaseFirestore.instance.collection(request.status + " requests")
        .doc(request.requestedAt)
        .set({
      'name': request.name,
      'email': request.email,
      'course': request.course,
      'question': request.question,
      'requested at': request.requestedAt,
      'status': request.status,
      "request taken at": request.requestTakenAt,
      "request finished at": request.requestFinishedAt,
      "time spent": request.timeSpent,
      "taken by": request.takenBy,
      "taker email": request.takerEmail,
      "waited time": request.waitedTime,
      "department": request.department,
    })
        .then((value) {
          print("New Request Added");
          sendAEmail();
    })
        .catchError((error) => print("Failed to save new request: $error"));
  }

  static void updateNewRequest(Request request) {
    FirebaseFirestore.instance.collection("new requests")
        .doc(request.requestedAt)
        .update({
      'name': request.name,
      'email': request.email,
      'course': request.course,
      'question': request.question,
      'requested at': request.requestedAt,
      'status': request.status,
      "request taken at": request.requestTakenAt,
      "request finished at": request.requestFinishedAt,
      "time spent": request.timeSpent,
      "taken by": request.takenBy,
      "taker email": request.takerEmail,
      "waited time": request.waitedTime,
      "department": request.department,
    })
        .then((value) => print("Request Updated"))
        .catchError((error) => print("Failed to update request: $error"));
  }

  static void deleteNewRequest(Request request) {
    FirebaseFirestore.instance.collection("new requests")
        .doc(request.requestedAt)
        .delete()
        .then((value) => print("Request Deleted"))
        .catchError((error) => print("Failed to delete request: $error"));
  }

}
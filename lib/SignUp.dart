
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Universals.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  var name = "";
  var email = "";
  var password = "";
  var taSecretCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Sign Up"),
          backgroundColor: Universals.appBarColor,
        ),
      backgroundColor: Universals.backgroundColor,
      body:
        ListView(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.person), onPressed: null),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 10),
                      child: TextField(
                        onChanged: (value){
                          name = value;
                        },
                        decoration: InputDecoration(hintText: "Name"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.email), onPressed: null),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 10),
                      child: TextField(
                        onChanged: (value){
                          email = value;
                        },
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.lock), onPressed: null),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 10),
                      child: TextField(
                        onChanged: (value){
                          password = value;
                        },
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.code), onPressed: null),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 10),
                      child: TextField(
                        onChanged: (value){
                          taSecretCode = value;
                        },
                        decoration: InputDecoration(hintText: "TA secret code"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "No TA secret code? Get it from your professor.",
                textAlign: TextAlign.center,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () async {
                      print(email);
                      print(password);
                      print(taSecretCode);
                      print(Universals.taSecretCode);

                      if (name == "" || email == null || password == null || taSecretCode == null) {
                        Universals.showToast('Please complete all fields', Universals.toastMessageTypeWarning);
                      } else {
                        if (taSecretCode != Universals.taSecretCode) {
                          Universals.showToast('Wrong TA secret code ', Universals.toastMessageTypeWarning);
                        } else {
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            DatabaseInteractions.saveUserProfile(name, email);

                            // FirebaseAuth.instance.signOut();
                            print(userCredential);
                            Navigator.pop(context);
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak');
                              Universals.showToast('The password provided is too weak', Universals.toastMessageTypeWarning);
                            } else if (e.code == 'email-already-in-use') {
                              print('The account already exists for that email');
                              Universals.showToast("The account already exists for that email", Universals.toastMessageTypeWarning);
                            }
                            else if (e.code == 'invalid-email') {
                              print('Invalid email');
                              Universals.showToast("Invalid email", Universals.toastMessageTypeWarning);
                            }
                          }
                          catch (e) {
                            print(e);
                          }
                        }
                      }
                    },
                    color: Universals.buttonColor,
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],

        )



    );
  }
}


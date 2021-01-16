import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/MainPage.dart';
import 'package:virtual_approval_flutter/SendRequestPage.dart';
import 'package:virtual_approval_flutter/SignUp.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/Universals.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  var email = "";
  var password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text("Sign In"),
        //   backgroundColor: Universals.appBarColor,
        // ),
      backgroundColor: Universals.backgroundColor,
      body:
        ListView(
          children: [
            SizedBox(height: 20,),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () async {
                      print(email);
                      print(password);

                      if(email == "" || password == "") {
                        Universals.showToast("Please complete all fields", Universals.toastMessageTypeWarning);
                      } else {
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password
                          ).then((value) {
                            // print("I'm signing in!!!");
                            // setState(() {
                            //   Universals.buildScreens = [
                            //     SendRequestPage(),
                            //     InfosPage(),
                            //     FirebaseAuth.instance.currentUser == null ?
                            //     SignIn() : TutorRequestsPage(),
                            //   ];
                            // });
                            return value;
                          });


                          print(userCredential);
                          //Navigator.popUntil(context, (route) => false); // pop all past screens
                          //Navigator.pop(context); // pop current screen

                          if(userCredential != null) {
                            // sign in
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => TutorRequestsPage(),));
                            // // Navigator.popAndPushNamed(context, 'TutorRequestsPage');
                            // // Navigator.pushReplacementNamed(context, 'SendRequestPage');
                            // Navigator.pop(context);
                            // pushNewScreen(
                            //   context,
                            //   screen: TutorRequestsPage(),
                            //   withNavBar: true, // OPTIONAL VALUE. True by default.
                            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            // );

                            print("I'm signing in!!!");


                            DatabaseInteractions.getLoggedInUserInformation(email);

                            // FocusScope.of(context).requestFocus(new FocusNode());




                          }

                        } on FirebaseAuthException catch (e) {
                          print(e);
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            Universals.showToast('No user found for that email', Universals.toastMessageTypeWarning);
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            Universals.showToast('Wrong password provided for that user', Universals.toastMessageTypeWarning);
                          } else if (e.code == 'invalid-email') {
                            print('invalid-email');
                            Universals.showToast('Invalid email', Universals.toastMessageTypeWarning);
                          } else {
                            Universals.showToast("Something went wrong", Universals.toastMessageTypeWarning);
                          }
                        }
                      }





                    },
                    color: Universals.buttonColor,
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.all(5.0),
                child:
                TextButton(
                  onPressed: () {
                    // Respond to button press
                    DatabaseInteractions.getTaSecretCode();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));
                  },
                  child: Text("Register"),
                )
            ),
          ],
        ),

    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/MainPage.dart';
import 'package:virtual_approval_flutter/SendRequestPage.dart';
import 'package:virtual_approval_flutter/SignUp.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: data.name,
            password: data.password
        ).then((value) {
          return value;
        });

        print(userCredential);
        if(userCredential != null) {
          print("I'm signing in!!!");
          DatabaseInteractions.getLoggedInUserInformation(data.name);
        }

      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          // UniversalMethods.showToast('No user found for that email', UniversalValues.toastMessageTypeWarning);
          return 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          // UniversalMethods.showToast('Wrong password provided for that user', UniversalValues.toastMessageTypeWarning);
          return 'Password does not match';
        } else if (e.code == 'invalid-email') {
          print('invalid-email');
          // UniversalMethods.showToast('Invalid email', UniversalValues.toastMessageTypeWarning);
          return 'Invalid email';
        } else {
          // UniversalMethods.showToast("Something went wrong", UniversalValues.toastMessageTypeWarning);
          return 'Something went wrong';
        }
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'Username not exists';
      // }
      return null;
    });
  }

  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text("Sign In"),
        //   backgroundColor: Universals.appBarColor,
        // ),
      backgroundColor: UniversalValues.backgroundColor,
      body:
       Container (
         // margin: const EdgeInsets.only(bottom: 20.0),
          child: FlutterLogin(
            title: 'BYUH',
            // logo: 'assets/images/ecorp-lightblue.png',
            onLogin: _authUser,
            onSignup: _authUser,
            onSubmitAnimationCompleted: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => TutorRequestsPage(),));
            },
            onRecoverPassword: _recoverPassword,

          ),

        )


    );
  }
}


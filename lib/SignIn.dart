import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/SignUp.dart';
import 'package:virtual_approval_flutter/Universals.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("SignIn"),
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

                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                            password: password
                        );
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          Universals.showToast('No user found for that email');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          Universals.showToast('Wrong password provided for that user');
                        }
                      }


                    },
                    color: Universals.buttonColor,
                    child: Text(
                      'SIGN In',
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
                padding: const EdgeInsets.all(20.0),
                child:
                TextButton(
                  onPressed: () {
                    // Respond to button press
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));
                  },
                  child: Text("Register"),
                )

            ),
          ],
        )

    );
  }
}


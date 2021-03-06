import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/MainPage.dart';
import 'package:virtual_approval_flutter/SendRequestPage.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:virtual_approval_flutter/UserInformation.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  Duration get loginTime => Duration(milliseconds: 2000);

  var name = "";
  var taSecretCode = "";
  var department;

  TextEditingController departmentTextEditingController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<String> signIn(LoginData data) {
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

  final _formKey = GlobalKey<FormState>();
  BuildContext buildContext;

  Future<String> signUp(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {

      DatabaseInteractions.getTaSecretCode();

      Future.delayed(Duration(milliseconds: 1000)).then((_) async {
      });

      // AwesomeDialog(
      //   dialogBackgroundColor: Colors.white,
      //   // width: 500,
      //   context: buildContext,
      //   headerAnimationLoop: true,
      //   dialogType: DialogType.QUESTION,
      //   useRootNavigator: true,
      //   // btnOkOnPress: () async {},
      //   onDissmissCallback: () {
      //     if (FirebaseAuth.instance.currentUser == null) {
      //       // Navigator.pop(context);
      //       // Navigator.push(buildContext, MaterialPageRoute(builder: (context) => SignIn(),));
      //     }
      //
      //   },
      //     // Navigator.of(context, rootNavigator: true).pop();
      //   body:
      //
      // )..show();

      var boxConstraints = BoxConstraints(minWidth: 100, maxWidth: 250);
      var boxColor = Colors.white;
      Future.delayed(Duration(milliseconds: 1)).then((_) async {

        showCupertinoModalBottomSheet(
          // expand: false,
          // bounce: true,
          useRootNavigator: true,
          context: context,
          duration: Duration(milliseconds: 700),
          builder: (context) =>
              Scaffold(
                backgroundColor: Colors.blue,
                body: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(minWidth: 150, maxWidth: 350),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        // color: Colors.redAccent,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),

                            ListTile(
                              title: const Text(
                                'A Couple More Things',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // IconButton(icon: Icon(Icons.house), onPressed: null),
                                  Container(
                                    color: boxColor,
                                    constraints: boxConstraints,
                                    margin: EdgeInsets.only(left: 10),
                                    child:
                                    DropdownSearch<String>(
                                        hint: "Department",
                                        mode: Mode.MENU,
                                        searchBoxDecoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                          ),
                                        ),
                                        showSelectedItem: true,
                                        items: UniversalValues.departments,
                                        // label: "Menu mode",
                                        // hint: "country in menu mode",
                                        // popupItemDisabled: (String s) => s.startsWith('I'),
                                        onChanged: (value) {
                                          department = value;
                                        },
                                        selectedItem: department
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // IconButton(icon: Icon(Icons.person), onPressed: null),
                                  Container(
                                    color: boxColor,
                                    constraints: boxConstraints,
                                    margin: EdgeInsets.only(left: 10),
                                    child: TextField(
                                      onChanged: (value){
                                        name = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Name",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // IconButton(icon: Icon(Icons.code), onPressed: null),
                                  Container(
                                    color: boxColor,
                                    constraints: boxConstraints,
                                    margin: EdgeInsets.only(left: 10),
                                    child: TextField(
                                      onChanged: (value){
                                        taSecretCode = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "TA secret code",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            // Padding(
                            //     padding: const EdgeInsets.all(20.0),
                            //     child: Text(
                            //       "No TA secret code? Get it from your professor.",
                            //       textAlign: TextAlign.center,
                            //     )
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  // color: boxColor,
                                  // constraints: boxConstraints,
                                  height: 60,
                                  child: NiceButton(
                                    width: 250,
                                    radius: 40,
                                    padding: const EdgeInsets.all(15),
                                    // icon: Icons.account_box,
                                    gradientColors: [Color(0xff5b86e5), Color(0xff36d1dc)],
                                    text: "Sign Up",
                                    onPressed: () async {
                                      print(taSecretCode);
                                      print(UniversalValues.taSecretCode);
                                      // Navigator.of(context, rootNavigator: true).pop();
                                      if (name == "" || taSecretCode == "" || department == "") {
                                        UniversalMethods.showToast('Please complete all fields', UniversalValues.toastMessageTypeWarning);
                                      } else {
                                        if (taSecretCode != UniversalValues.taSecretCode) {
                                          UniversalMethods.showToast('Wrong TA secret code ', UniversalValues.toastMessageTypeWarning);
                                        } else {
                                          try {
                                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                              email: data.name,
                                              password: data.password,
                                            );

                                            UserInformation userInformation = new UserInformation(name: name, email: data.name, department: department);

                                            DatabaseInteractions.saveUserProfile(userInformation);

                                            UniversalValues.loggedInUserInformation = userInformation;

                                            // FirebaseAuth.instance.signOut();
                                            print(userCredential);
                                            // Navigator.pop(context);
                                            Navigator.of(context, rootNavigator: true).pop();
                                          }
                                          on FirebaseAuthException catch (e) {
                                            if (e.code == 'weak-password') {
                                              print('The password provided is too weak');
                                              UniversalMethods.showToast('The password provided is too weak', UniversalValues.toastMessageTypeWarning);
                                            } else if (e.code == 'email-already-in-use') {
                                              print('The account already exists for that email');
                                              UniversalMethods.showToast("The account already exists for that email", UniversalValues.toastMessageTypeWarning);
                                            }
                                            else if (e.code == 'invalid-email') {
                                              print('Invalid email');
                                              UniversalMethods.showToast("Invalid email", UniversalValues.toastMessageTypeWarning);
                                            }
                                          }
                                          catch (e) {
                                            print(e);
                                          }
                                        }
                                      }

                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                )


              )
        );
        // showModalBottomSheet<void>(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return Container(
        //       height: 800,
        //       color: Colors.amber,
        //       child: Center(
        //         child:
        //       ),
        //     );
        //   },
        // );
      });
      return "Please fill out more info";


      // return null;

    });
  }

  Future<String> recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'Username not exists';
      // }
      return "You cannot set you password";
      // return null;
    });
  }

  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {

    buildContext = context;

    return Scaffold(
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text("Sign In"),
        //   backgroundColor: Universals.appBarColor,
        // ),
      // resizeToAvoidBottomInset: true,

        key: _scaffoldKey,
      backgroundColor: UniversalValues.backgroundColor,
      body:
       Container (
         // margin: const EdgeInsets.only(bottom: 20.0),
          child: FlutterLogin(
            title: 'BYU Hawaii',
            logo: 'assets/images/byu_hawaii_medallion_logo.png',
            onLogin: signIn,
            onSignup: signUp,
            onSubmitAnimationCompleted: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => TutorRequestsPage(),));

            },
            onRecoverPassword: recoverPassword,
            // showDebugButtons: true,


          ),

        )


    );
  }
}


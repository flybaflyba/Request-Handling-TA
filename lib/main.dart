import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/HomePage.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/MainPage.dart';
import 'package:virtual_approval_flutter/SendRequestPage.dart';
import 'package:virtual_approval_flutter/SignIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // if (FirebaseAuth.instance.currentUser != null) {
    //   DatabaseInteractions.getLoggedInUserInformation(FirebaseAuth.instance.currentUser.email);
    // }

    return MaterialApp(
      title: 'BYUH Tutors',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: "MyHomePage",
      routes: {
        "SendRequestPage" : (context) => SendRequestPage(),
        // "MyHomePage" : (context) => HomePage(),
        // Set app launch screen, if user is signed in, show ta page, if not, show send request page
        "MyHomePage" : (context) => MainPage(menuScreenContext: context, initialIndex: FirebaseAuth.instance.currentUser == null ? 0 : 2,),
        "TutorRequestsPage" : (context) => TutorRequestsPage(),

      },
    );
  }
}


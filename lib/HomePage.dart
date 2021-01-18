import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/SendRequestPage.dart';
import 'package:virtual_approval_flutter/SignIn.dart';


// We are not using this page as this page's bottom nav bar is not persistent


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;


  PageController pageController;


  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text(
            "BYUH Tutoring",
            textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        )),
        toolbarHeight: 50,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() => currentIndex = index);
          },
          children: <Widget>[
            // Container(color: Colors.blueGrey,),
            // Container(color: Colors.red,),
            // Container(color: Colors.green,),
            // Container(color: Colors.blue,),
            new SendRequestPage(),
            new InfosPage(),
            new SignIn(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
          pageController.jumpToPage(index);
          print(FirebaseAuth.instance.currentUser);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Help'),
              icon: Icon(Icons.question_answer)
          ),
          BottomNavyBarItem(
              title: Text('Info'),
              icon: Icon(Icons.info)
          ),
          BottomNavyBarItem(
              title: Text('TA'),
              icon: Icon(Icons.person)
          ),

        ],
      ),


    );
  }
}
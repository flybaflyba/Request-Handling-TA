


import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:intl/intl.dart';
import 'package:virtual_approval_flutter/ViewRequestPage.dart';
import 'package:virtual_approval_flutter/RequestsHistoryPage.dart';


class TutorRequestsPage extends StatefulWidget {
  @override
  _TutorRequestsPageState createState() => _TutorRequestsPageState();
}


class _TutorRequestsPageState extends State<TutorRequestsPage> with SingleTickerProviderStateMixin {

  var department = "";

  Animation<double> _animation;
  AnimationController _animationController;


  @override
  void initState() {

    _animationController = AnimationController(
     vsync: this,
      duration: Duration(milliseconds: 300),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();

    // it might take some time to get user info from database once app launches
    new Timer.periodic(Duration(seconds:1), (Timer t) {

      // print("hihihi");
      // print(UniversalValues.loggedInUserInformation);

      if (UniversalValues.loggedInUserInformation != null) {
        setState(() {
          department = UniversalValues.loggedInUserInformation == null ? "" : UniversalValues.loggedInUserInformation.department;
        });
        t.cancel();
      } else {
        if (FirebaseAuth.instance.currentUser != null) {
          // when web refresh, loggedInUserInformation gets lost, so we get them again here
          DatabaseInteractions.getLoggedInUserInformation(FirebaseAuth.instance.currentUser.email);
        }

      }



    });


  }

  StreamBuilder<QuerySnapshot> requestsList(String filterBy, String filterByValue, String showIfNoResult) {
    return
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('new requests')
            .where('department', isEqualTo: department)
            .where(filterBy, isEqualTo: filterByValue)
            .snapshots(),
        builder: (context, snapshot){
          List<Widget> requestsWidget = [];

          List<Widget> noRequestsWidget = [];
          noRequestsWidget.add(
            Center(
              child: Text(
                showIfNoResult,
              ),
            ),
          );

          if(snapshot.hasData){
            final content = snapshot.data.documents;
            for(var requestDocumentSnapshot in content){
              Request request = new Request();
              request.setRequestInfoWithDocumentSnapshot(requestDocumentSnapshot);
              final contentToDisplay =
              Column(
                children: [
                  FlatButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        if(request.status == "new") {
                          // i don't know why i don't need to do that time zone conversion here...  sometimes...
                          var requestTakenTime = new DateTime.now();
                          print(requestTakenTime.add(Duration(hours: 0)));
                          var requestTakenTimeHawaii = requestTakenTime.add(Duration(hours: 0)).toString();
                          request.requestTakenAt = requestTakenTimeHawaii;
                          request.takenBy = FirebaseAuth.instance.currentUser.uid;
                          request.takerEmail = FirebaseAuth.instance.currentUser.email;
                          // delete request once it's taken.
                          // DatabaseInteractions.deleteRequest(request);
                          request.status = "taken";
                          request.waitedTime = DateTime.now().add(Duration(hours: 0)).difference(DateTime.parse(request.requestedAt)).toString();
                        }


                        DatabaseInteractions.updateNewRequest(request);

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRequestPage(request: request,),));
                        pushNewScreen(
                          context,
                          screen: ViewRequestPage(request: request,),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );


                      },
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              request.requestedAt.toString().substring(0, 16),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Text(
                                  request.name,
                                ),
                              ),
                              Center(
                                child: Text(
                                  request. course,
                                ),
                              ),
                            ],
                          )



                        ],
                      )
                  ),
                  SizedBox(height: 10,),
                ],
              );
              requestsWidget.add(contentToDisplay);
            }
          }
          return Column(
              children: requestsWidget.length != 0 ? requestsWidget : noRequestsWidget
          );
        },
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text("New Requests List"),
        //   backgroundColor: Universals.appBarColor,
        // ),

        backgroundColor: UniversalValues.backgroundColor,
        body:
      Column(
        children: [

          UniversalMethods.titleText(department),

          Row(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: RequestsHistoryPage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );},
                child: Icon(Icons.history, color: Colors.blueGrey,),
              ),
              FlatButton(
                onPressed: () {
                  AwesomeDialog(
                      context: context,
                      useRootNavigator: true,
                      headerAnimationLoop: true,
                      dialogType: DialogType.SUCCES,
                      title: 'Thank You!',
                      desc: "We appreciate your help.",
                      autoHide: Duration(seconds: 5),
                      width: 500
                  )..show();
                },
                child: Icon(Icons.favorite, color: Colors.pink,),
              ),
              FlatButton(
                onPressed: () {
                  AwesomeDialog(
                      context: context,
                      useRootNavigator: true,
                      headerAnimationLoop: true,
                      dialogType: DialogType.SUCCES,
                      title: 'Good Job!',
                      desc: "You are such a good TA.",
                      autoHide: Duration(seconds: 5),
                      width: 500
                  )..show();
                },
                child: Icon(Icons.beach_access, color: Colors.blue,),
              ),
              FlatButton(
                onPressed: () {
                  AwesomeDialog(
                      context: context,
                      useRootNavigator: true,
                      headerAnimationLoop: true,
                      dialogType: DialogType.SUCCES,
                      title: 'Relax!',
                      desc: "Don't for get the take a break.",
                      autoHide: Duration(seconds: 5),
                      width: 500
                  )..show();
                },
                child: Icon(Icons.audiotrack, color: Colors.green,),
              )
            ],
          ),

          Expanded(child:
          Center(
              child: Container(
                constraints: BoxConstraints(minWidth: 150, maxWidth: 800),
                child: ListView(
                  children: [
                    UniversalMethods.titleText("Helping"),

                    requestsList('taker email', FirebaseAuth.instance.currentUser.email, 'You Have not Taken any Request'),

                    Divider(
                      color: Colors.blue,
                      height: 20,
                      thickness: 5,
                      indent: 20,
                      endIndent: 20,
                    ),



                    UniversalMethods.titleText('New Requests'),

                    requestsList('status', "new", 'There is no New Request'),

                    SizedBox(height: 200,)


                  ],
                ),
              )),
          )
        ],
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,


    );
  }
}



import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:intl/intl.dart';
import 'package:virtual_approval_flutter/ViewRequestPage.dart';
import 'package:virtual_approval_flutter/RequestsHistoryPage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TutorRequestsPage extends StatefulWidget {
  @override
  _TutorRequestsPageState createState() => _TutorRequestsPageState();
}


class _TutorRequestsPageState extends State<TutorRequestsPage> with SingleTickerProviderStateMixin {

  var department = "";

  Animation<double> _animation;
  AnimationController _animationController;

  var isMusicOn = false;


  Future<void> loadMusic() async {
    try {
      await UniversalValues.musicPlayer.setUrl('https://firebasestorage.googleapis.com/v0/b/virtual-approval-flutter.appspot.com/o/i_am_a_child_of_god.mp3?alt=media&token=c128aa53-4c0f-4e5f-82c2-97e6139b647a');
      UniversalValues.musicPlayer.setLoopMode(LoopMode.one);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      print("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web: a generic message
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all errors
      print(e);
    }
  }


  @override
  Future<void> initState() {

    loadMusic();

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
                onPressed: () async {


                  if (kIsWeb) {
                    // launch url
                    const url = 'https://translate.google.com/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  } else {
                    showCupertinoModalBottomSheet(
                      // expand: false,
                      // bounce: true,
                        useRootNavigator: true,
                        context: context,
                        duration: Duration(milliseconds: 700),
                        builder: (context) =>
                            Scaffold(
                              appBar: AppBar(title: Text("Translator",),),
                              body: WebviewScaffold(url: "https://translate.google.com/",),
                            )
                    );
                  }

                  // AwesomeDialog(
                  //     context: context,
                  //     useRootNavigator: true,
                  //     headerAnimationLoop: true,
                  //     dialogType: DialogType.SUCCES,
                  //     title: 'Thank You!',
                  //     desc: "We appreciate your help.",
                  //     autoHide: Duration(seconds: 5),
                  //     width: 500
                  // )..show();
                },
                child: Icon(Icons.translate, color: Colors.pink,),
              ),
              FlatButton(
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    // expand: false,
                    // bounce: true,
                      useRootNavigator: true,
                      context: context,
                      duration: Duration(milliseconds: 700),
                      builder: (context) =>
                          Scaffold(
                            appBar: AppBar(title: Text("Translator",),),
                            body: Center(
                              child: Container(
                                constraints: BoxConstraints(minWidth: 150, maxWidth: 450),
                                child: SimpleCalculator(
                                  // value: 123.45,
                                  // hideExpression: false,
                                  onChanged: (key, value, expression) {
                                    /*...*/
                                  },
                                  theme: const CalculatorThemeData(
                                    displayColor: Colors.black,
                                    displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
                                  ),
                                ),
                              ),
                            )
                          )
                  );


                  // AwesomeDialog(
                  //     context: context,
                  //     useRootNavigator: true,
                  //     headerAnimationLoop: true,
                  //     dialogType: DialogType.SUCCES,
                  //     title: 'Good Job!',
                  //     desc: "You are such a good TA.",
                  //     autoHide: Duration(seconds: 5),
                  //     width: 500
                  // )..show();
                },
                child: Icon(Icons.calculate, color: Colors.blue,),
              ),
              FlatButton(
                onPressed: () async {

                  print(UniversalValues.musicPlayer.playerState);
                  print(isMusicOn);

                  if (isMusicOn) {
                    await UniversalValues.musicPlayer.pause();
                    setState(() {
                      isMusicOn = false;
                    });
                  } else {
                    UniversalMethods.showToast("Enjoy the music!", UniversalValues.toastMessageTypeGood);
                    UniversalValues.musicPlayer.play();
                    setState(() {
                      isMusicOn = true;
                    });

                  }

                },
                child: Icon(isMusicOn ? Icons.motion_photos_pause : Icons.audiotrack, color: Colors.green,),
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
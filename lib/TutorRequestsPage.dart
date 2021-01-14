


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/Universals.dart';
import 'package:intl/intl.dart';

class TutorRequestsPage extends StatefulWidget {
  @override
  _TutorRequestsPageState createState() => _TutorRequestsPageState();
}


class _TutorRequestsPageState extends State<TutorRequestsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text("New Requests List"),
        //   backgroundColor: Universals.appBarColor,
        // ),
        backgroundColor: Universals.backgroundColor,
        body:
            ListView(
              children: [

                SizedBox(height: 20,),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('new requests')
                      .snapshots(),
                  builder: (context, snapshot){
                    List<Widget> requestsWidget = [];
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
                              DatabaseInteractions.updateNewRequest(request);

                              showGeneralDialog(
                                context: context,
                                // barrierColor: Colors.black12.withOpacity(0.6), // background color
                                barrierDismissible: false, // should dialog be dismissed when tapped outside
                                barrierLabel: "Dialog", // label for barrier
                                transitionDuration: Duration(milliseconds: 400), // how long it takes to popup dialog after button click
                                pageBuilder: (_, __, ___) { // your widget implementation
                                  return SizedBox.expand( // makes widget fullscreen
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox.expand(
                                            child: RaisedButton(
                                              color: Universals.transparentColorWhite,
                                              child: Text(
                                                "Helping",
                                                style: TextStyle(fontSize: 40),
                                              ),
                                              textColor: Colors.white,
                                              onPressed: () {
                                                // Navigator.pop(context);
                                                },
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 4,
                                          child: SizedBox.expand(
                                            child: RaisedButton(
                                              color: Universals.transparentColorWhite,
                                              child: ListView(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(child: Text(request.name),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child:  Center(child: Text(request.email),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(child: Text(request.course),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(child: Text("requested at " + request.requestedAt.toString().substring(0, 16)),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(child: Text("request is taken at " + request.requestTakenAt.toString().substring(0, 16)),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(child:
                                                    Text(
                                                      "Question:",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                    ),
                                                  ),
                                                  Center(child: Text(request.question),),
                                                ],
                                              ),
                                              textColor: Colors.white,
                                              onPressed: () {
                                                // Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox.expand(
                                            child: RaisedButton(
                                              color: Universals.transparentColorWhite,
                                              child:
                                              StreamBuilder<DateTime>(
                                                stream: Stream.periodic(const Duration(seconds: 1)),
                                                builder: (context, snapshot) {
                                                  return Center(
                                                    child: Text(
                                                      "Time Spent: " +
                                                      DateTime.now().difference(requestTakenTime).toString().substring(0,7),
                                                    ),
                                                  );
                                                },
                                              ),
                                              textColor: Colors.white,
                                              onPressed: () {
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox.expand(
                                            child: RaisedButton(
                                              color: Universals.buttonColor,
                                              child: Text(
                                                "Finish",
                                                style: TextStyle(fontSize: 40),
                                              ),
                                              textColor: Colors.white,
                                              onPressed: () {
                                                // print("done helping");
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).then((val){
                                print("done helping");
                                var requestDoneTime = new DateTime.now();
                                print(requestDoneTime.add(Duration(hours: 0)));
                                var requestDoneTimeHawaii = requestDoneTime.add(Duration(hours: 0)).toString();
                                request.requestFinishedAt = requestDoneTimeHawaii;
                                request.timeSpent = DateTime.now().difference(requestTakenTime).toString();
                                request.status = "done";
                                print(request.show());
                                // save request to done requests collections and delete from new requests collection
                                DatabaseInteractions.saveRequest(request);
                                DatabaseInteractions.deleteRequest(request);
                              });

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
                      children: requestsWidget,
                    );
                  },
                ),

              ],
            )
    );
  }
}
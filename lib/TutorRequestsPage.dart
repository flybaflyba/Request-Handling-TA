


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/Universals.dart';
import 'package:intl/intl.dart';
import 'package:virtual_approval_flutter/ViewRequestPage.dart';

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

                Center(
                  child: Text(
                    'Requests You Took',
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('new requests')
                      .where('taker email', isEqualTo: Universals.loggedInUserInformation.email)
                      .snapshots(),
                  builder: (context, snapshot){
                    List<Widget> requestsWidget = [];

                    List<Widget> noRequestsWidget = [];
                    noRequestsWidget.add(
                      Center(
                        child: Text(
                          'You Have not Taken any Request',
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

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRequestPage(request: request,),));

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
                ),

                Divider(
                  color: Colors.blue,
                  height: 20,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),


                Center(
                  child: Text(
                    'New Requests',
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('new requests')
                      .where('status', isEqualTo: 'new')
                      .snapshots(),
                  builder: (context, snapshot){

                    List<Widget> requestsWidget = [];

                    List<Widget> noRequestsWidget = [];
                    noRequestsWidget.add(
                      Center(
                        child: Text(
                          'There is no New Request',
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

                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRequestPage(request: request,),));

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
                ),

              ],
            )
    );
  }
}
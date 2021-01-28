


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:intl/intl.dart';
import 'package:virtual_approval_flutter/ViewRequestPage.dart';

class RequestsHistoryPage extends StatefulWidget {
  @override
  _RequestsHistoryPageState createState() => _RequestsHistoryPageState();
}


class _RequestsHistoryPageState extends State<RequestsHistoryPage> {

  StreamBuilder<QuerySnapshot> requestsList(String filterBy, String filterByValue, String showIfNoResult) {
    return
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('done requests')
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
            final content = snapshot.data.docs;
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
                      },
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Center(
                            child: Text(
                              "Requested time: " + request.requestedAt.toString().substring(0, 16),
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Text(
                                  "waited " + request.waitedTime.substring(0,7),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "spent " + request.timeSpent.substring(0,7),
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
        Center(
          child: Container(
            constraints: BoxConstraints(minWidth: 150, maxWidth: 800),
            child: ListView(
              children: [
                SizedBox(height: 20,),
                UniversalMethods.titleText('Your Requests History'),
                requestsList('taker email', FirebaseAuth.instance.currentUser.email, 'There is no Request'),
                SizedBox(height: 100,)

              ],
            ),
          ),
        )

    );
  }
}
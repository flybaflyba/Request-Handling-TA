


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:intl/intl.dart';
import 'package:virtual_approval_flutter/ViewRequestPage.dart';

// ignore: must_be_immutable
class StudentRequestsPage extends StatefulWidget {

  StudentRequestsPage({Key key, this.emailPassedIn}) : super(key: key);

  var emailPassedIn;

  @override
  _StudentRequestsPageState createState() => _StudentRequestsPageState();
}


class _StudentRequestsPageState extends State<StudentRequestsPage> {

  var email = "";

  TextEditingController textEditingController = new TextEditingController();

  StreamBuilder<QuerySnapshot> requestsList(String filterBy, String filterByValue, String showIfNoResult) {

    return
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('new requests')
            .where(filterBy, isEqualTo: email)
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
                      },
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Requested at " + request.requestedAt.toString().substring(0, 16),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Text(
                                  request.status,
                                ),
                              ),
                              Center(
                                child: Text(
                                  request. course,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Text(
                              request.question,
                            ),
                          ),

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
        backgroundColor: UniversalValues.backgroundColor,
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
                        controller: textEditingController,
                        onChanged: (value){
                          setState(() {
                            email = value;
                            print(email);
                          });

                        },
                        decoration: InputDecoration(hintText: "Your BYUH Email"),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Text(
                'Your Requests',
              ),
            ),

            requestsList('email', email, !EmailValidator.validate(email) ? "Enter your email address" : 'You Haven\'t Sent Any Request'),

            SizedBox(height: 100,)

          ],
        )
    );
  }
}
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtual_approval_flutter/Request.dart';

class Universals {
  static Color appBarColor = Color(0xff2b9ed4);
  static Color buttonColor = Color(0xff0077d7);
  static Color backgroundColor = Color(0xffffffff);
  static Color transparentColorWhite = Color(0x55000000);
  static Color toastMessageTypeGood = Colors.blue;
  static Color toastMessageTypeWarning = Colors.red;

  static String taSecretCode = "";

  static const courses =
  '''[
    {"CIS": ["101","202","205","206"]},
    {"CS": ["203","210","301","490R"]},
    {"IT": ["224","240","280","320","390R","420","480"]},
    {"IS": [350]},
    {"MATH": ["107","110","111","119","121","212","213","301","421"]},
    {"PHYS": ["115","115L","121","121L"]},
    {"Other": ["Other"]}
    ]''';

  static void showToast(String msg, Color toastMessageType) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: toastMessageType,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showRequestInfoToStudentInRealTime(String email, BuildContext context) {

    showGeneralDialog(
      context: context,
      // barrierColor: Colors.black12.withOpacity(0.6), // background color
      barrierDismissible: false, // should dialog be dismissed when tapped outside
      barrierLabel: "Dialog", // label for barrier
      transitionDuration: Duration(milliseconds: 400), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) { // your widget implementation
        return SizedBox.expand( // makes widget fullscreen
          child:
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('new requests')
                  .where('email', isEqualTo: email)
                  .snapshots(),
              builder: (context, snapshot){
                var requestInfo = Column(children: [Text("HI")],);
                if(snapshot.hasData){
                  // final content = snapshot.data.documents[0];
                  print(snapshot.data.docs.length);
                  final content = snapshot.data.documents[0];
                  var name = content["name"];
                  var email = content["email"];
                  var course = content["course"];
                  var question = content["question"];
                  var requestedTimeHawaii = content["requested time hawaii"];
                  var status = content["status"];
                  Request request = new Request(name: name, email: email, course: course, question: question, requestedTimeHawaii: requestedTimeHawaii, status: status);


                  requestInfo =
                      Column(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: SizedBox.expand(
                              child: RaisedButton(
                                color: Universals.transparentColorWhite,
                                child: Text(
                                  "Waiting",
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
                            flex: 12,
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
                                      child: Center(child: Text("requested at " + request.requestedTimeHawaii.toString().substring(0, 16)),),
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
                            flex: 3,
                            child: SizedBox.expand(
                              child: RaisedButton(
                                color: Universals.transparentColorWhite,
                                child:
                                StreamBuilder<DateTime>(
                                  stream: Stream.periodic(const Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    return
                                      Center(
                                        child:
                                        Text(
                                          "Time Waited: " +
                                              DateTime.now().add(Duration(hours: -10)).difference(DateTime.parse(request.requestedTimeHawaii)).toString().substring(0, 7),
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
                            flex: 3,
                            child: SizedBox.expand(
                              child: RaisedButton(
                                color: Universals.buttonColor,
                                child: Text(
                                  "OK",
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
                      );
                }



                return requestInfo;

              }
          ),


        );
      },
    );

  }


}





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';

class UniversalMethods {


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

                  if (snapshot.data.docs.length == 0) {
                    // help finished
                    print("help finished");
                    requestInfo = Column(children: [
                      Expanded(
                        flex: 18,
                        child: SizedBox.expand(
                          child: RaisedButton(
                            color: UniversalValues.transparentColorWhite,
                            child: Text(
                              "Help Done",
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
                        flex: 3,
                        child: SizedBox.expand(
                          child: RaisedButton(
                            color: UniversalValues.buttonColor,
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
                    ]);

                  } else {
                    print("helping");
                    DocumentSnapshot requestDocumentSnapshot = snapshot.data.docs[0];
                    Request request = new Request();
                    request.setRequestInfoWithDocumentSnapshot(requestDocumentSnapshot);

                    requestInfo =
                        Column(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: SizedBox.expand(
                                child: RaisedButton(
                                  color: UniversalValues.transparentColorWhite,
                                  child: Text(
                                    request.takenBy == "" ?
                                    "Waiting" : "Coming!",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  textColor:
                                  request.takenBy == "" ?
                                  Colors.white : Colors.red,
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
                                  color:request.status == "taken" ?  UniversalValues.transparentColorRed : UniversalValues.transparentColorWhite,
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
                                        child: Center(child: Text("Requested at " + request.requestedAt.toString()),), //.substring(0, 16)
                                      ),
                                      request.takenBy != "" ?
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(child: Text("Request is taken at " + request.requestTakenAt.toString()),), //
                                      ) :
                                      SizedBox(height: 0,),
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
                                  color: request.status == "taken" ?  UniversalValues.transparentColorRed : UniversalValues.transparentColorWhite,
                                  child:
                                  StreamBuilder<DateTime>(
                                    stream: Stream.periodic(const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      return
                                        Center(
                                          child:
                                          request.takenBy == "" ?
                                          Text(
                                            "Time Waited: "
                                                + DateTime.now().add(Duration(hours: 0)).difference(DateTime.parse(request.requestedAt)).toString().substring(0, 7),
                                          ) : Text(
                                            "Your request is taken by " + request.takerEmail,
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
                                  color: UniversalValues.buttonColor,
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

                } else {
                  print("no data");
                }



                return requestInfo;

              }
          ),


        );
      },
    );

  }

}
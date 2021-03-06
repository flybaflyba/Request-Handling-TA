import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/SignIn.dart';
import 'package:virtual_approval_flutter/StudentRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalMethods.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:email_validator/email_validator.dart';

class SendRequestPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SendRequestPageState createState() => _SendRequestPageState();
}

class _SendRequestPageState extends State<SendRequestPage> {

  var name = "";
  var email = "";
  var course = "";
  var question = "";
  var department = "";

  TextEditingController courseTextEditingController = new TextEditingController();
  bool courseTextEditingEnable = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        key: _scaffoldKey,
      //   appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   backgroundColor: Universals.appBarColor,
      //   title: Text("BYUH Tutoring"),
      // ),
      body:
        Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minWidth: 150, maxWidth: 800),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  UniversalMethods.titleText("Send a Request"),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.person), onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child: TextField(
                              onChanged: (value){
                                name = value;
                              },
                              decoration: InputDecoration(hintText: "Name"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.email), onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child: TextField(
                              onChanged: (value){
                                email = value;
                              },
                              decoration: InputDecoration(hintText: "Your BYUH Email"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.menu_book), onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child:
                            TextField(
                              enabled: courseTextEditingEnable,
                              controller: courseTextEditingController,
                              onTap: () {
                                // courseTextEditingEnable = false;
                                FocusScope.of(context).requestFocus(new FocusNode()); // do not show keyboard
                                // show course picker
                                Picker picker = Picker(
                                  adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(UniversalValues.courses)),
                                  changeToFirst: false,
                                  textAlign: TextAlign.left,
                                  height: 200,
                                  magnification: 1,
                                  looping: false,
                                  textStyle: const TextStyle(color: Colors.blue),
                                  selectedTextStyle: TextStyle(color: Colors.red),
                                  columnPadding: const EdgeInsets.all(8.0),
                                  // footer: SizedBox(height: 50,),
                                  onConfirm: (Picker picker, List value) {
                                    print(value.toString()); // index
                                    print(picker.getSelectedValues());

                                    UniversalValues.departmentsAndCoursesMatch.forEach((key, value) {
                                      if (value.contains(picker.getSelectedValues()[0])) {
                                        department = key;
                                      }
                                    });
                                    // value
                                    course = picker.getSelectedValues()[0] + " " + picker.getSelectedValues()[1];
                                    print(course);
                                    courseTextEditingController.text = course;
                                    // courseTextEditingEnable = true;
                                  },
                                  onCancel: () {
                                    // courseTextEditingEnable = true;
                                  },
                                );
                                picker.show(_scaffoldKey.currentState);
                              },
                              decoration: InputDecoration(hintText: 'Course'),
                            ),


                          ),
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.question_answer), onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child:
                            TextField(
                              minLines: 1,
                              maxLines: 100,
                              // textAlign: TextAlign.center,
                              onChanged: (value) {
                                question = value;
                              },
                              decoration: InputDecoration(hintText: 'Question'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 60,
                        child: RaisedButton(
                          onPressed: () async {
                            print(name);
                            print(email);
                            print(course);
                            print(question);

                            if(name == "" || email == "" || course == "" || question == ""){
                              UniversalMethods.showToast("Please complete all fields", UniversalValues.toastMessageTypeWarning);
                            } else {
                              if (!EmailValidator.validate(email)) {
                                UniversalMethods.showToast("Invalid email", UniversalValues.toastMessageTypeWarning);
                              } else {
                                if(!email.contains("byuh")){
                                  UniversalMethods.showToast("Please use your BYUH email", UniversalValues.toastMessageTypeWarning);
                                } else {
                                  // check if this person has submitted a request
                                  try {
                                    // FirebaseFirestore.instance
                                    //     .collection('new requests')
                                    //     .where('email', isEqualTo: email)
                                    //     .get()
                                    //     .then((QuerySnapshot querySnapshot) {
                                    //   if (querySnapshot.docs.isNotEmpty) {
                                    //     String requestMessageBack = "You already submitted a request";
                                    //     print(requestMessageBack);
                                    //     UniversalMethods.showToast(requestMessageBack, UniversalValues.toastMessageTypeWarning);
                                    //   } else {
                                    //     String requestMessageBack = "Your Requested is submitted successfully";
                                    //     print(requestMessageBack);
                                    //     UniversalMethods.showToast(requestMessageBack, UniversalValues.toastMessageTypeGood);
                                    //     Request request = new Request(name: name, email: email, course: course, question: question);
                                    //     var now = new DateTime.now();
                                    //     print(now.add(Duration(hours: 0))); // do we need to use -10 to convert to hawaii time?
                                    //     var nowHawaii = now.add(Duration(hours: 0)).toString();
                                    //     request.requestedAt = nowHawaii;
                                    //     request.status = "new";
                                    //     DatabaseInteractions.saveRequest(request);
                                    //   }
                                    //
                                    //   UniversalMethods.showRequestInfoToStudentInRealTime(email, context);
                                    //
                                    // }).then((value) {
                                    //   FocusScope.of(context).requestFocus(new FocusNode()); // do not show keyboard
                                    // });

                                    Request request = new Request(name: name, email: email, course: course, question: question, department: department);
                                    var now = new DateTime.now();
                                    print(now.add(Duration(hours: 0))); // do we need to use -10 to convert to hawaii time?
                                    var nowHawaii = now.add(Duration(hours: 0)).toString();
                                    request.requestedAt = nowHawaii;
                                    request.status = "new";
                                    DatabaseInteractions.saveRequest(request);


                                    String requestMessageBack = "Your Requested is submitted successfully";
                                    print(requestMessageBack);
                                    UniversalMethods.showToast(requestMessageBack, UniversalValues.toastMessageTypeGood);

                                    // UniversalMethods.showRequestInfoToStudentInRealTime(email, context);
                                    FocusScope.of(context).requestFocus(new FocusNode()); // do not show keyboard

                                    print(department);

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentRequestsPage(emailPassedIn: email),));

                                  } catch(e) {
                                    print("something went wrong");
                                  }
                                }

                              }

                            }


                          },
                          color: UniversalValues.buttonColor,
                          child: Text(
                            'Request Help',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),




                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentRequestsPage(),));
                        },
                        child: Text("Check My Requests"),
                      )

                  ),

                  // Padding(
                  //     padding: const EdgeInsets.all(5.0),
                  //     child:
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(),));
                  //       },
                  //       child: Text("Are you a TA?"),
                  //     )
                  //
                  // ),
                  // SizedBox(height: 100,)

                ],

              ),
            ),
          )
        )
    );
  }
}

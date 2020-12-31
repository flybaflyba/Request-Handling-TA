


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/Universals.dart';

class TutorHomePage extends StatefulWidget {
  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}


class _TutorHomePageState extends State<TutorHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Requests List"),
          backgroundColor: Universals.appBarColor,
        ),
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

                      for(var c in content){
                        final name = c.get('name');
                        final course = c.get('course');
                        final contentToDisplay =

                        Column(
                          children: [
                            FlatButton(
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => ViewItinerary(plan: plan),
                              //     )
                              // );

                            },
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                      child: Text(
                                        name,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        course,
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
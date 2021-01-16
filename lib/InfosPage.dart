import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/OneInfoPage.dart';
import 'package:virtual_approval_flutter/SignUp.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';


class InfosPage extends StatefulWidget {
  @override
  _InfosPageState createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {

  List tabs = ["CIS", "MATH", "ACCT", "PHYS", "ENGL", "REL", "ENTR", "ART", "BIOL", "BUSM", "HIST", "TESOL", "EIL"];

  @override
  Widget build(BuildContext context) {
    return
      new DefaultTabController(
        length: tabs.length,
        child:
        new Scaffold(
          appBar: AppBar(
            toolbarHeight: 50,
            bottom: TabBar(   //生成Tab菜单
              isScrollable: true,
              tabs: tabs.map((e) => Tab(text: e)).toList(),
              // labelColor: Colors.red,
              // indicatorColor: Colors.amber,
            ),
          ),

          body: new TabBarView(
            children: tabs.map((e) { //分别创建对应的Tab页面
              return Container(
                alignment: Alignment.center,
                child:
                // Text(e, textScaleFactor: 5),
                // new OneInfoPage(subject: e,),


                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('subjects information')
                      .doc(e.toLowerCase())
                      // .doc("cis")
                      .snapshots(),
                  builder: (context, snapshot){
                    // print("------------------");
                    // print(snapshot.data.data());
                    // print(snapshot.hasData);
                    if(snapshot.data != null && snapshot.data.exists){
                      final DocumentSnapshot subjectDocument = snapshot.data;
                      // tempTest = subjectDocument["hours"];
                      // print("document id is " + subjectDocument.id);

                      // print(snapshot.data.exists);
                      return new OneInfoPage(subject: e, subjectDocument: subjectDocument,);
                    } else {
                      print("document not found");
                      return new OneInfoPage(subject: e,);
                    }
                    return CircularProgressIndicator();
                  },

                ),


              );
            }).toList(),
          ),
        ),
      );
  }
}


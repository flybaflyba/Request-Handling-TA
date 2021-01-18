import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/OneInfoPage.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


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

                // !kIsWeb ?
                // // WebView(
                // //   initialUrl: "https://docs.google.com/document/d/1D4GOGP2NS1PmC6NUbEtkAPdRRXwBAB9MrbIrhlbihog/edit?usp=sharing",
                // //
                // // )
                // WebviewScaffold(
                //   url: "https://docs.google.com/document/d/1D4GOGP2NS1PmC6NUbEtkAPdRRXwBAB9MrbIrhlbihog/edit?usp=sharing",
                //
                //   withZoom: true,
                //   withLocalStorage: true,
                //   hidden: true,
                //   initialChild: Container(
                //     color: Colors.blueAccent,
                //     child: const Center(
                //       child: Text('Waiting.....'),
                //     ),
                //   ),
                // )
                //     :
                //     Center(
                //       child: RaisedButton(
                //         child: Icon(Icons.open_in_browser),
                //         onPressed: () async {
                //           const url = "https://docs.google.com/document/d/1D4GOGP2NS1PmC6NUbEtkAPdRRXwBAB9MrbIrhlbihog/edit?usp=sharing";
                //           if (await canLaunch(url)) {
                //           await launch(url);
                //           } else {
                //           throw 'Could not launch $url';
                //           }
                //         },
                //       ),
                //     ),



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


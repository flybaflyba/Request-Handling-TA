import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/SignUp.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/Universals.dart';


class OneInfoPage extends StatefulWidget {

  OneInfoPage({Key key, this.subject, this.subjectDocument}) : super(key: key);

  final String subject;
  final DocumentSnapshot subjectDocument;

  @override
  _OneInfoPageState createState() => _OneInfoPageState();
}

class _OneInfoPageState extends State<OneInfoPage> {

  List tabs = ["Hours", "Info", "Help"];

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
              // isScrollable: true,
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
                    widget.subjectDocument == null ? Text(widget.subject + " " + e, textScaleFactor: 5) :
                 Text(widget.subject + " " + e + widget.subjectDocument[e.toLowerCase()], textScaleFactor: 5),


              );
            }).toList(),
          ),
        ),
      );
  }
}


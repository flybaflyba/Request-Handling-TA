import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/OneInfoPage.dart';
import 'package:virtual_approval_flutter/SignUp.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/Universals.dart';


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
                new OneInfoPage(subject: e,),


              );
            }).toList(),
          ),
        ),
      );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';


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
              return
              //   Container(
              //   alignment: Alignment.center,
              //   child:
              //
              // )

                ListView(
                  children: [
                    widget.subjectDocument == null ?

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                        Column(
                          children: [
                            SizedBox(height: 110,),
                            Text(
                              "No" + " " + widget.subject + " " + e + " " + "Information",
                              textAlign: TextAlign.center,
                              textScaleFactor: 3,),
                          ],
                        )
                    )

                        :
                    // Text(widget.subjectDocument[e.toLowerCase()]),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                      HtmlWidget(
                        // the first parameter (`html`) is required
                        widget.subjectDocument[e.toLowerCase()],

                        // all other parameters are optional, a few notable params:

                        // specify custom styling for an element
                        // see supported inline styling below
                        // customStylesBuilder: (element) {
                        //   if (element.classes.contains('foo')) {
                        //     return {'color': 'red'};
                        //   }
                        //   return null;
                        // },

                        // set the default styling for text
                        // textStyle: TextStyle(fontSize: 14),

                        // By default, `webView` is turned off because additional config
                        // must be done for `PlatformView` to work on iOS.
                        // https://pub.dev/packages/webview_flutter#ios
                        // Make sure you have it configured before using.
                        webView: true,
                      ),
                    ),

                  ],
                )



              ;
            }).toList(),
          ),
        ),
      );
  }
}


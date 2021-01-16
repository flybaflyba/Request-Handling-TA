


import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/UniversalValues.dart';

class ViewRequestPage extends StatefulWidget {

  ViewRequestPage({Key key, this.request}) : super(key: key);

  var request;

  @override
  _ViewRequestPagState createState() => _ViewRequestPagState();
}

class _ViewRequestPagState extends State<ViewRequestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SizedBox.expand( // makes widget fullscreen
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox.expand(
                child: RaisedButton(
                  color: UniversalValues.transparentColorWhite,
                  child: Text(
                    "Helping",
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
              flex: 4,
              child: SizedBox.expand(
                child: RaisedButton(
                  color: UniversalValues.transparentColorWhite,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(child: Text(widget.request.name),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:  Center(child: Text(widget.request.email),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(child: Text(widget.request.course),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(child: Text("requested at " + widget.request.requestedAt.toString().substring(0, 16)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(child: Text("request is taken at " + widget.request.requestTakenAt.toString().substring(0, 16)),),
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
                      Center(child: Text(widget.request.question),),
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
              flex: 1,
              child: SizedBox.expand(
                child: RaisedButton(
                  color: UniversalValues.transparentColorWhite,
                  child:
                  StreamBuilder<DateTime>(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Center(
                        child: Text(
                          "Time Spent: " +
                              DateTime.now().difference(DateTime.parse(widget.request.requestTakenAt)).toString().substring(0,7),
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
              flex: 1,
              child: SizedBox.expand(
                child: RaisedButton(
                  color: UniversalValues.buttonColor,
                  child: Text(
                    "Finish",
                    style: TextStyle(fontSize: 40),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    // print("done helping");
                    Navigator.of(context).pop();

                    print("done helping");
                    var requestDoneTime = new DateTime.now();
                    print(requestDoneTime.add(Duration(hours: 0)));
                    var requestDoneTimeHawaii = requestDoneTime.add(Duration(hours: 0)).toString();
                    widget.request.requestFinishedAt = requestDoneTimeHawaii;
                    widget.request.timeSpent = DateTime.now().difference(DateTime.parse(widget.request.requestTakenAt)).toString();
                    widget.request.status = "done";
                    print(widget.request.show());
                    // save request to done requests collections and delete from new requests collection
                    DatabaseInteractions.saveRequest(widget.request);
                    DatabaseInteractions.deleteNewRequest(widget.request);


                  },
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
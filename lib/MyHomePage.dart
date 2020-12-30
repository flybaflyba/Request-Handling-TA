import 'package:flutter/material.dart';
import 'package:virtual_approval_flutter/DatabaseInteractions.dart';
import 'package:virtual_approval_flutter/SignIn.dart';
import 'package:virtual_approval_flutter/Universals.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var name = "";
  var email = "";
  var course = "";
  var question = "";

  TextEditingController courseTextEditingController = new TextEditingController();
  bool courseTextEditingEnable = true;

  Future<void> _showCourseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Course', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        // value: dropdownValue,
                        value: course,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            // dropdownValue = newValue;
                            course = newValue;
                            print(course);
                            courseTextEditingController.text = course;
                            courseTextEditingEnable = true;
                            Navigator.of(context).pop();
                          });
                        },
                        items: Universals.courses
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text('Confirm'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Universals.appBarColor,
        title: Text(widget.title),
      ),
      body:      ListView(
        children: [
          SizedBox(height: 20,),
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
                      decoration: InputDecoration(hintText: "Email"),
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
                        courseTextEditingEnable = false;
                        FocusScope.of(context).requestFocus(new FocusNode()); // do not show keyboard
                        _showCourseDialog();
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

                    DatabaseInteractions.saveNewRequest(name, email, course, question);



                  },
                  color: Universals.buttonColor,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(),));
                },
                child: Text("Are you a TA?"),
              )

          ),
        ],

      )
    );
  }
}

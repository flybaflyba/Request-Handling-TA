import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                            // = value;
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
                    IconButton(icon: Icon(Icons.lock), onPressed: null),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          onChanged: (value){
                            // = value;
                          },
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )


    );
  }
}


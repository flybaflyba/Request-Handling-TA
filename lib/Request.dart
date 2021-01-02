
import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  var name = "";
  var email = "";
  var course = "";
  var question = "";
  var requestedAt = "";
  var status = "";

  var requestTakenAt = "";
  var requestFinishedAt = "";
  var timeSpent = "";

  var takenBy = "";
  var takerEmail = "";

  var waitedTime = "";

  Request({
    var email,
    var name,
    var course,
    var question,
    var requestedTimeHawaii,
    var status,
  }){
    if(email != null){ this.email = email; }
    if(name != null){ this.name = name; }
    if(course != null){ this.course = course; }
    if(question != null){ this.question = question; }
    if(requestedTimeHawaii != null){ this.requestedAt = requestedTimeHawaii; }
    if(status != null){ this.status = status; }
  }

  void setRequestInfoWithDocumentSnapshot(DocumentSnapshot requestDocumentSnapshot) {
    name = requestDocumentSnapshot["name"];
    email = requestDocumentSnapshot["email"];
    course = requestDocumentSnapshot["course"];
    question = requestDocumentSnapshot["question"];
    requestedAt = requestDocumentSnapshot["requested at"];
    status = requestDocumentSnapshot["status"];
    requestTakenAt = requestDocumentSnapshot["request taken at"];
    requestFinishedAt = requestDocumentSnapshot["request finished at"];
    timeSpent = requestDocumentSnapshot["time spent"];
    takenBy = requestDocumentSnapshot["taken by"];
    takerEmail = requestDocumentSnapshot["taker email"];
    waitedTime = requestDocumentSnapshot["waited time"];
  }

  List show() {
    return [email,
      name,
      course,
      question,
      requestedAt,
      status,
      requestTakenAt,
      requestFinishedAt,
      timeSpent,
      takenBy,
      takerEmail,
      waitedTime,
    ];
  }



}
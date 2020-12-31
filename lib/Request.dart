
class Request {
  var name = "";
  var email = "";
  var course = "";
  var question = "";
  var requestedTimeHawaii = "";
  var status = "";

  var requestTakenTimeHawaii = "";
  var requestDoneTimeHawaii = "";
  var timeSpent = "";

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
    if(requestedTimeHawaii != null){ this.requestedTimeHawaii = requestedTimeHawaii; }
    if(status != null){ this.status = status; }
  }

  List show() {
    return [email,
      name,
      course,
      question,
      requestedTimeHawaii,
      status,
      requestTakenTimeHawaii,
      requestDoneTimeHawaii,
      timeSpent,
    ];
  }


}
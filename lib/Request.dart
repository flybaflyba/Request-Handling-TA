
class Request {
  var name;
  var email;
  var course;
  var question;
  var requestedTime;
  var status;

  Request({
    var email,
    var name,
    var course,
    var question,
    var requestedTime,
    var status
  }){
    if(email != null){ this.email = email; }
    if(name != null){ this.name = name; }
    if(course != null){ this.course = course; }
    if(question != null){ this.question = question; }
    if(requestedTime != null){ this.requestedTime = requestedTime; }
    if(status != null){ this.status = status; }

  }

}
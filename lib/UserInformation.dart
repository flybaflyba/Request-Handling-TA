
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation {
  var name = "";
  var email = "";
  var department = "";

  UserInformation({
    var name,
    var email,
    var department,
  }){
    if(name != null){ this.name = name; }
    if(email != null){ this.email = email; }
    if(department != null){ this.department = department; }
  }

  void setUserInfoWithDocumentSnapshot(DocumentSnapshot userDocumentSnapshot) {
    name = userDocumentSnapshot["name"];
    email = userDocumentSnapshot["email"];
    department = userDocumentSnapshot["department"];
  }

  List show() {
    return [email,
      name,
      department,
    ];
  }
}
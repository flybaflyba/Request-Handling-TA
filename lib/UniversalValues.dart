import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:virtual_approval_flutter/InfosPage.dart';
import 'package:virtual_approval_flutter/Request.dart';
import 'package:virtual_approval_flutter/SendRequestPage.dart';
import 'package:virtual_approval_flutter/SignIn.dart';
import 'package:virtual_approval_flutter/TutorRequestsPage.dart';
import 'package:virtual_approval_flutter/UserInformation.dart';

class UniversalValues {
  static Color appBarColor = Color(0xff2b9ed4);
  static Color buttonColor = Color(0xff0077d7);
  static Color backgroundColor = Color(0xffffffff);
  static Color transparentColorWhite = Color(0x55000000);
  static Color transparentColorRed = Color(0x55ff0000);
  static Color toastMessageTypeGood = Colors.blue;
  static Color toastMessageTypeWarning = Colors.red;

  static String taSecretCode = "";

  static const courses =
  '''[
    {"CIS": ["101","202","205","206"]},
    {"CS": ["203","210","301","490R"]},
    {"IT": ["224","240","280","320","390R","420","480"]},
    {"IS": [350]},
    {"MATH": ["107","110","111","119","121","212","213","301","421"]},
    {"PHYS": ["115","115L","121","121L"]},
    {"FILM": ["102", "218", "318", "300", "365R"]},
    {"ENTR": ["180", "283", "275", "285", "373", "380", "383", "375R", "390R", "401R", "483", "485", "499"]}
    ]''';

  static const departments = ["Arts & Letters", "Business & Government", "Culture, Language & Performing Arts", "Education & Social Work",
    "Math & Computing", "Religious Education", "Sciences"];

  static const Map<String, List<String>> departmentsAndCoursesMatch = {
    'Arts & Letters': ["FILM"],
    'Business & Government':  ["ENTR"],
    'Culture, Language & Performing Arts':  [],
    'Education & Social Work':  [],
    'Math & Computing':  ["CIS", "CS", "IT", "IS", "MATH"],
    'Religious Education':  [],
    'Sciences':  ["PHYS",],
  };

  static UserInformation loggedInUserInformation;
  static var loggedInLast = FirebaseAuth.instance.currentUser == null ? false : true;

  static AudioPlayer musicPlayer = AudioPlayer();



}
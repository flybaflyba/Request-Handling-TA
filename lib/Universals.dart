import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Universals {
  static Color appBarColor = Color(0xff2b9ed4);
  static Color buttonColor = Color(0xff0077d7);
  static Color backgroundColor = Color(0xffffffff);
  static Color transparentColorWhite = Color(0x55000000);
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
    {"Other": ["Other"]}
    ]''';

  static void showToast(String msg, Color toastMessageType) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: toastMessageType,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


}
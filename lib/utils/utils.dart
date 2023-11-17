import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  static void toastMessage(
      {required String msg,
      required Color bgColor,
      required Color txtColor,
      int time = 2}) {
    Fluttertoast.showToast(
        msg: msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: time,
        backgroundColor: bgColor,
        textColor: txtColor,
        fontSize: 16.0);
  }
}

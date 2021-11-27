//@dart = 2.9
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void disposeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showToast(String msg) {
  Fluttertoast.showToast(msg: msg);
}

getStringDate(DateTime newDate) {
  return "${newDate.day < 10 ? "0${newDate.day}" : newDate.day}-${newDate.month < 10 ? "0${newDate.month}" : newDate.month}-${newDate.year}";
}

checkDate(DateTime a, DateTime b) {
  if (a == null || b == null) return false;
  return ((a.day == b.day) && (a.month == b.month) && (a.year == b.year));
}

getDate() {}

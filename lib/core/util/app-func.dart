//@dart = 2.9
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void disposeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showToast(String msg) {
  Fluttertoast.showToast(msg: msg);
}

getStringDate(DateTime newDate) {
  return DateFormat('dd-MM-yyyy').format(newDate);
}

checkDate(DateTime a, DateTime b) {
  if (a == null || b == null) return false;
  return ((a.day == b.day) && (a.month == b.month) && (a.year == b.year));
}

isSameHour(DateTime a, DateTime b) {
  return ((a.difference(b).inDays == 0) && checkDate(a, b) && a.hour == b.hour);
}

getDate() {}

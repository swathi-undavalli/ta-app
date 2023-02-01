import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/attendance/attendance-model.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AttendancePageLogic {
  AttendancePageController controller = Get.put(AttendancePageController());

  AttendancePageLogic(employee) {
    if (employee != null)
      controller.currentEmployee = employee;
    else
      controller.currentEmployee = currentEmployee;
    getDates();
    getAbsentDates();
    getClockData();
  }

  reset() {
    controller.currentEmployee = null;
    controller.clockData = null;
  }

  getAbsentDates() async {
    controller.absentDates = [];
    controller.showLoading = true;
    //print("started=====================");
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("employees")
        .doc(controller.currentEmployee!.id)
        .collection("attendance")
        .where("punctual", isEqualTo: "Absent")
        .get();

    for (int i = 0; i < data.docs.length; i++) {
      Map<String, dynamic> attendanceData = data.docs[i].data();
      var attandence = Attendance.fromMap(attendanceData);
      //print("============== ${data.docs[i].id}");
      if (attandence.LogTime != null)
        controller.absentDates.add(attandence.LogTime!.toDate());
    }
    //print(controller.absentDates);
    controller.update();
    controller.showLoading = false;

    //print("ended=====================");
  }

  getDates() {
    //log("getDates");
    controller.calenderDates = [];
    DateTime firstDay = DateTime(
        controller.selectedDate.year, controller.selectedDate.month, 1);
    var temp = firstDay;
    while (temp.month == controller.selectedDate.month) {
      controller.calenderDates.add(temp);
      temp = temp.add(Duration(days: 1));
    }
  }

  getOrderOfDates() {
    //log("getOrderOfDates");
    DateTime firstDay = DateTime(
        controller.selectedDate.year, controller.selectedDate.month, 1);
    for (int i = 0; i < controller.days.length; i++) {
      String day = DateFormat('EE').format(firstDay);
      if (day == controller.days[i]) {
        return i;
      }
    }
  }

  datePicker(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2021, 10, 27),
        maxTime: DateTime(2022, 10, 27), onChanged: (date) {
      //print('change $date');
      controller.selectedDate = date;
    }, onConfirm: (date) {
      //print('confirm $date');
      controller.selectedDate = date;
      // getAbsentDates();
      getDates();
      controller.update();
    },
        currentTime: controller.selectedDate,
        theme: DatePickerTheme(
          cancelStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            color: Colors.black87,
          ),
          doneStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          itemStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
  }

  getClockData() async {
    //print("getClockData");
    var data = await FirebaseFirestore.instance
        .collection("employees")
        .doc(controller.currentEmployee!.id)
        .collection("attendanceClock")
        .doc(DateFormat("MM-yyyy").format(DateTime.now()))
        .get();

    if (data.data() != null)
      controller.clockData = data.data()!["clockDuration"];
    else
      controller.clockData = null;

    //print(controller.clockData);
  }

  getPositiveNumber(int num) {
    if (num < 0) return num * -1;
    return num;
  }

  getTimeFromSeconds(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec ~/ 60) % 60;
    int seconds = sec - (hours * 3600 + minutes * 60);
    hours = getPositiveNumber(hours);
    minutes = getPositiveNumber(minutes);
    return "${(hours < 10) ? "0$hours" : "$hours"} : ${(minutes < 10) ? "0$minutes" : "$minutes"}";
  }
}

class AttendancePageController extends GetxController {
  Employee? currentEmployee;

  List<DateTime> calenderDates = [];
  List<DateTime> absentDates = [];

  List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  String? _date;
  int? _clockData = 0;

  bool _showLoading = false;

  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
  );

  DateTime get selectedDate => _selectedDate;

  String? get date => _date;

  bool get showLoading => _showLoading;
  int? get clockData => _clockData;

  set clockData(int? value) {
    _clockData = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set date(String? value) {
    _date = value;
    update();
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    update();
  }
}

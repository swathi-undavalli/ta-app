import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageBoatsLogic {
  ManageBoatsController controller = Get.put(ManageBoatsController());

  getDates() {
    var temp = DateTime.now().subtract(Duration(days: 10));
    for (int i = 0; i < 20; i++) {
      temp = temp.add(Duration(days: 1));
      controller.calenderDates.add(temp);
    }
  }

  getTime() {
    controller.timeTable = [];
    var temp = DateTime(
      controller.selectedDate.year,
      controller.selectedDate.month,
      controller.selectedDate.day,
      4,
    );
    for (int i = 0; i < 18; i++) {
      temp = temp.add(Duration(hours: 1));
      controller.timeTable.add(temp);
    }
  }
}

class ManageBoatsController extends GetxController {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> calenderDates = [];
  List<DateTime> timeTable = [];

  get selectedDate => _selectedDate;

  set selectedDate(value) {
    _selectedDate = value;
    update();
  }
}

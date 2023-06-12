import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AllFreelanceLogic {
  AllFreelanceController controller = Get.put(AllFreelanceController());

  void updateSearchList(String text) {
    controller.suggestionsList = [];
    //print(controller.allEmployeesList[controller.allEmployeesList.length - 1].id);
    controller.allFreelanceList.forEach((employee) {
      if (employee.firstName!.toLowerCase().contains(text.toLowerCase()) ||
          employee.lastName!.toLowerCase().contains(text.toLowerCase()) ||
          employee.id.contains(text)) {
        controller.suggestionsList.add(employee);
      }
    });
    controller.update();
  }


}

class AllFreelanceController extends GetxController {
  TextEditingController searchTED = TextEditingController();

  List<String> roles = [
    "DiveTeam",
    "Bookings",
    "Servicing",
    "AdminTeam",
    "Manager",
    "Accounts",
    "Marketing"
  ];

  List<Employee> allFreelanceList = [];

  List<Employee> suggestionsList = [];

  TextEditingController optionsTEDDe = TextEditingController();

  List<String> options = ['Call', 'Delete', "Info"];

  List<Employee> employees = [];

  bool _showSuggestions = false;

  int _data = 0;

  bool get showSuggestions => _showSuggestions;

  int get data => _data;

  set data(int value) {
    _data = value;
    update();
  }

  set showSuggestions(bool value) {
    _showSuggestions = value;
    update();
  }
}

///TODO :: CHECK PLEASE


import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AllEmployeesLogic {
  AllEmployeesController controller = Get.put(AllEmployeesController());
  void updateSearchList(String text) {
    controller.suggestionsList = [];
    controller.allEmployeesList.forEach((employee) {
      if (employee.firstName.toLowerCase().contains(text.toLowerCase()) ||
          employee.lastName.toLowerCase().contains(text.toLowerCase())) {
        controller.suggestionsList.add(employee);
      }
    });
    controller.update();
  }
}

class AllEmployeesController extends GetxController {
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

  List<Employee> allEmployeesList = [];
  List<Employee> suggestionsList = [];


  TextEditingController optionsTEDDe = TextEditingController();

  List<String> options = ['Call', 'Delete', "Info"];

  List<Employee> employees = [];

  bool _showSuggestions = false;


  bool get showSuggestions => _showSuggestions;

  set showSuggestions(bool value) {
    _showSuggestions = value;
    update();
  }


}

///TODO :: CHECK PLEASE

// class AllEmployeesLogic {
//   AllEmployeesController controller = Get.put(AllEmployeesController());
//   void updateSearchList(String text) {
//     controller.suggestionsList = [];
//     controller.allEmployeesList.forEach((employee) {
//       if (employee.firstName.toLowerCase().contains(text.toLowerCase()) ||
//           employee.lastName.toLowerCase().contains(text.toLowerCase())) {
//         controller.suggestionsList.add(employee);
//       }
//     });
//     controller.update();
//   }
// }
//
// class AllEmployeesController extends GetxController {
//   TextEditingController searchTED = TextEditingController();
//
//   List<String> roles = [
//     "DiveTeam",
//     "Bookings",
//     "Servicing",
//     "AdminTeam",
//     "Manager",
//     "Accounts",
//     "Marketing"
//   ];
//
//   List<Employee> allEmployeesList = [];
//   List<Employee> suggestionsList = [];
//
//   Icon _customIcon = Icon(Icons.search);
//
//   Widget _customSearchBar = Text('Search');
//
//   TextEditingController optionsTEDDe = TextEditingController();
//
//   List<String> options = ['Call', 'Delete', "Info"];
//
//   List<Employee> employees = [];
//
//   bool _showSuggestions = false;
//
//   Icon get customIcon => _customIcon;
//
//   Widget get customSearchBar => _customSearchBar;
//
//   bool get showSuggestions => _showSuggestions;
//
//   set showSuggestions(bool value) {
//     _showSuggestions = value;
//     update();
//   }
//
//   set customSearchBar(Widget value) {
//     _customSearchBar = value;
//     update();
//   }
//
//   set customIcon(Icon value) {
//     _customIcon = value;
//     update();
//   }
// }

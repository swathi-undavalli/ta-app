import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class EditBoatLogic {
  EditBoatController controller = Get.put(EditBoatController());
}

class EditBoatController extends GetxController {
  BoatsModel boatsModel;
  TextEditingController boatCapacityTED = TextEditingController();
  TextEditingController captainNameTED = TextEditingController();
  TextEditingController phoneTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();

  FocusNode boatCapacityNode = FocusNode();
  FocusNode captainNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();

  String _boatName;

  reset() {
    boatCapacityTED.text = "";
    captainNameTED.text = "";
    phoneTED.text = "";
  }

  int _employeeCount;

  bool _showLoading = true;

  String get boatName => _boatName;

  int get employeeCount => _employeeCount;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set boatName(String value) {
    _boatName = value;
    update();
  }

  set employeeCount(int value) {
    _employeeCount = value;
    update();
  }

  List<Employee> allEmployeesList = [];

  String _isoCode = "IN";

  String get isoCode => _isoCode;

  set isoCode(String value) {
    _isoCode = value;
    update();
  }
}

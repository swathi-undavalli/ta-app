import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/employee.dart';

class EmployeeProfileLogic {
  EmployeeProfileController controller = Get.put(EmployeeProfileController());
  EmployeeProfileLogic() {
    init();
  }

  void init() {
    controller.startDate = currentEmployee?.leaves?.first.toDate();
    controller.endDate = currentEmployee?.leaves?.last.toDate();
  }
}

class EmployeeProfileController extends GetxController {
  FocusNode phoneNumberNode = FocusNode();
  FocusNode nameNode = FocusNode();

  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController nameTED = TextEditingController();

  bool _isEditMode = false;
  DateTimeRange? dateRange;

  DateTime? startDate;
  DateTime? endDate;
  List<Timestamp> leaves = [];

  bool _showLoading = false;

  String _isoCode = "IN";

  bool get isEditMode => _isEditMode;

  String get isoCode => _isoCode;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set isoCode(String value) {
    _isoCode = value;
    update();
  }

  set isEditMode(bool value) {
    _isEditMode = value;
    update();
  }

  reset() {
    phoneNumberTED.text = "";
    nameTED.text = "";
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeProfileLogic {
  EmployeeProfileController controller = Get.put(EmployeeProfileController());
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

  String _isoCode = "IN";

  bool get isEditMode => _isEditMode;

  String get isoCode => _isoCode;

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

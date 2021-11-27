import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:intl/intl.dart';

class AddAnUserLogic {
  AddAnUserController controller = Get.put(AddAnUserController());
  Employee employee;
  DateTime pickedTime = DateTime.now();

  onSubmit() {
    //TODO: Change.
    if (controller.firstNameTED.text != "" &&
        controller.employeeIdTED.text != "" &&
        controller.shiftTimeTED.text != "" &&
        controller.phoneNumberTED.text != "" &&
        controller.countryCodeTED.text != "" &&
        controller.genderTED.text != "" &&
        controller.roleTED.text != "") {
      Employee employee = Employee(
        firstName: controller.firstNameTED.text,
        lastName: controller.lastNameTED.text,
        id: controller.employeeIdTED.text,
        phoneNumber: controller.phoneNumberTED.text,
        countryCode: controller.countryCodeTED.text,
        role: controller.roleTED.text,
        gender: controller.genderTED.text,
        shiftTiming: pickedTime,
        countryIsoCode: controller.countryISoCOde,
        accessLevels: AccessLevels(
            attendence: controller.attendanceSwitch,
            booking: controller.bookingSwitch),
      );
      FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.id)
          .collection('employeeFullInformation')
          .doc('employeeData')
          .set(employee.toMap());
      Fluttertoast.showToast(msg: "Saved");
      disposeKeyboard();
      Get.back();
    } else {
      Fluttertoast.showToast(msg: "Invalid Input");
    }
    controller.reset();
  }

  timePicker(context) {
    DatePicker.showTimePicker(context, showTitleActions: true,
        onChanged: (time) {
      print('change $time');
      pickedTime = time;
      controller.shiftTimeTED.text = DateFormat.Hm().format(time);
    }, onConfirm: (newTime) {
      print('confirm $pickedTime');
      pickedTime = newTime;
      controller.shiftTimeTED.text = DateFormat.Hm().format(pickedTime);
    },
        currentTime: pickedTime,
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
}

class AddAnUserController extends GetxController {
  TextEditingController firstNameTED = TextEditingController();
  TextEditingController lastNameTED = TextEditingController();
  TextEditingController employeeIdTED = TextEditingController();
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController roleTED = TextEditingController();
  TextEditingController accessLevelTED = TextEditingController();
  TextEditingController genderTED = TextEditingController();
  TextEditingController shiftTimeTED = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode employeeIdNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode countryCodeNode = FocusNode();
  FocusNode roleNode = FocusNode();
  FocusNode accessLevelNode = FocusNode();
  FocusNode genderNode = FocusNode();
  FocusNode shiftTimeNode = FocusNode();

  List<String> gender = ['Male', 'Female'];

  List<String> _roles = [
    'Manager',
    'dive team',
    'admin team',
    'accounts',
    'servicing',
    'marketing',
    'bookings'
  ];

  bool _attendanceSwitch = false;

  bool _bookingSwitch = false;

  String _countryISoCOde;

  bool get bookingSwitch => _bookingSwitch;

  bool get attendanceSwitch => _attendanceSwitch;

  List<String> get roles => _roles;

  String get countryISoCOde => _countryISoCOde;

  set countryISoCOde(String value) {
    _countryISoCOde = value;
    update();
  }

  set bookingSwitch(bool value) {
    _bookingSwitch = value;
    update();
  }

  set attendanceSwitch(bool value) {
    _attendanceSwitch = value;
    update();
  }

  set roles(List<String> value) {
    _roles = value;
    update();
  }

  reset() {
    firstNameTED.text = "";
    lastNameTED.text = "";
    phoneNumberTED.text = "";
    countryCodeTED.text = "";
    roleTED.text = "";
    shiftTimeTED.text = "";
    genderTED.text = "";
    employeeIdTED.text = "";
    bookingSwitch = false;
    attendanceSwitch = false;
  }
}

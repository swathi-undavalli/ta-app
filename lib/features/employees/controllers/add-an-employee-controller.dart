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
          viewBookings: controller.viewBookings,
          createBookings: controller.createBookings,
          editBookings: controller.editBookings,
          viewEmployees: controller.viewEmployees,
          createEmployees: controller.createEmployees,
          editEmployees: controller.editEmployees,
          personalProfileEdit: controller.personalProfileEdit,
          personalAttendanceReport: controller.personalAttendanceReport,
          attendanceReport: controller.attendanceReport,
          weatherReport: controller.weatherReport,
          editActivityPrices: controller.editActivityPrices,
          addActivity: controller.addActivity,
        ),
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

  ///Switches
  bool _viewBookings = false;
  bool _weatherReport = false;

  bool _createBookings = false;
  bool _editBookings = false;
  bool _personalAttendanceReport = false;
  bool _editActivityPrices = false;
  bool _addActivity = false;
  bool _editEmployees = false;
  bool _personalProfileEdit = false;
  bool _attendanceReport = false;
  bool _createEmployees = false;
  bool _viewEmployees = false;

  bool get viewBookings => _viewBookings;

  set viewBookings(bool value) {
    _viewBookings = value;
    update();
  }

  String _countryISoCOde;

  List<String> get roles => _roles;

  String get countryISoCOde => _countryISoCOde;

  set countryISoCOde(String value) {
    _countryISoCOde = value;
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
    viewBookings = false;
    createBookings = false;
    editBookings = false;
    viewEmployees = false;
    createEmployees = false;
    editEmployees = false;
    personalProfileEdit = false;
    personalAttendanceReport = false;
    attendanceReport = false;
    weatherReport = false;
    editActivityPrices = false;
    addActivity = false;
  }

  bool get createBookings => _createBookings;

  set createBookings(bool value) {
    _createBookings = value;
    update();
  }

  bool get editBookings => _editBookings;

  set editBookings(bool value) {
    _editBookings = value;
    update();
  }

  bool get viewEmployees => _viewEmployees;

  set viewEmployees(bool value) {
    _viewEmployees = value;
    update();
  }

  bool get createEmployees => _createEmployees;

  set createEmployees(bool value) {
    _createEmployees = value;
    update();
  }

  bool get editEmployees => _editEmployees;

  set editEmployees(bool value) {
    _editEmployees = value;
    update();
  }

  bool get personalProfileEdit => _personalProfileEdit;

  set personalProfileEdit(bool value) {
    _personalProfileEdit = value;
    update();
  }

  bool get personalAttendanceReport => _personalAttendanceReport;

  set personalAttendanceReport(bool value) {
    _personalAttendanceReport = value;
    update();
  }

  bool get attendanceReport => _attendanceReport;

  set attendanceReport(bool value) {
    _attendanceReport = value;
    update();
  }

  bool get weatherReport => _weatherReport;

  set weatherReport(bool value) {
    _weatherReport = value;
    update();
  }

  bool get editActivityPrices => _editActivityPrices;

  set editActivityPrices(bool value) {
    _editActivityPrices = value;
    update();
  }

  bool get addActivity => _addActivity;

  set addActivity(bool value) {
    _addActivity = value;
    update();
  }
}

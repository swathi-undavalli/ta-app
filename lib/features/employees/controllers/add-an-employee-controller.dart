import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

class AddAnUserLogic {
  final DateFormat formatter = DateFormat('HH:mm');

  AddAnUserController controller = Get.put(AddAnUserController());
  Employee? employee;

  createEmployee() async {
    //TODO: Change.
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("count")
        .get();
    CounterModel counterModel = CounterModel.fromMap(data.data()!);

    if (controller.firstNameTED.text != "" &&
        controller.employeeIdTED.text != "" &&
        controller.shiftTimeTED.text != "" &&
        controller.phoneNumberTED.text != "" &&
        controller.countryCodeTED.text != "" &&
        // controller.genderTED.text != "" &&
        controller.roleTED.text != "") {
      Employee employee = Employee(
        firstName: controller.firstNameTED.text,
        lastName: controller.lastNameTED.text,
        id: controller.employeeIdTED.text,
        phoneNumber: controller.phoneNumberTED.text,
        countryCode: controller.countryCodeTED.text,
        role: controller.roleTED.text,
        gender: controller.genderTED.text,
        shiftTiming: controller.pickedTime,
        countryIsoCode: controller.countryISoCOde,
        agencyId: controller.agencyIdTED.text,
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
          notifications: controller.notifications,
        ),
      );
      // viewBookings: controller.viewBookings,
      FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.id)
          // .collection('employeeFullInformation')
          // .doc('employeeData')
          .set(employee.toMap());

      if (counterModel.employee != null) {
        counterModel.employee = counterModel.employee! + 1;
      }

      FirebaseFirestore.instance
          .collection("counter")
          .doc("count")
          .set(counterModel.toMap());
      Fluttertoast.showToast(msg: "Saved");
      LogModel logModel =
          LogModel(type: LogType.addEmployee, employeeName: employee.name);
      FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());

      disposeKeyboard();
      Get.back();
      Get.back();
      Get.back();
      controller.reset();
    } else {
      Fluttertoast.showToast(msg: "Invalid Input");
    }
  }

  updateEmployee() async {
    if (controller.firstNameTED.text != "" &&
        controller.employeeIdTED.text != "" &&
        controller.shiftTimeTED.text != "") {
      Employee employee = Employee(
        firstName: controller.firstNameTED.text,
        lastName: controller.lastNameTED.text,
        id: controller.employeeIdTED.text,
        phoneNumber: controller.phoneNumberTED.text,
        countryCode: controller.countryCodeTED.text,
        role: controller.roleTED.text,
        gender: controller.genderTED.text,
        shiftTiming: controller.pickedTime,
        countryIsoCode: controller.countryISoCOde,
        agencyId: controller.agencyIdTED.text,
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
          notifications: controller.notifications,
        ),
      );
      // viewBookings: controller.viewBookings,
      FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.id)
          // .collection('employeeFullInformation')
          // .doc('employeeData')
          .set(employee.toMap());
      LogModel logModel =
          LogModel(type: LogType.editEmployee, employeeName: employee.name);
      FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());

      Fluttertoast.showToast(msg: "Saved");
      disposeKeyboard();
      Get.back();
      Get.back();
      Get.back();
      controller.reset();
    } else {
      Fluttertoast.showToast(msg: "Invalid Input");
    }
  }

  timePicker(context) {
    DatePicker.showTimePicker(context,
        showTitleActions: true, showSecondsColumn: false, onChanged: (time) {
      //print('change $time');
      controller.pickedTime = time;
      controller.shiftTimeTED.text = formatter.format(time);
    }, onConfirm: (newTime) {
      //print('confirm $pickedTime');
      controller.pickedTime = newTime;
      controller.shiftTimeTED.text = formatter.format(newTime);
    },
        currentTime: controller.pickedTime,
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
  DateTime? pickedTime = DateTime.now();

  TextEditingController firstNameTED = TextEditingController();
  TextEditingController agencyIdTED = TextEditingController();
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
  FocusNode agencyIdNode = FocusNode();
  FocusNode employeeIdNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode countryCodeNode = FocusNode();
  FocusNode roleNode = FocusNode();
  FocusNode accessLevelNode = FocusNode();
  FocusNode genderNode = FocusNode();
  FocusNode shiftTimeNode = FocusNode();

  List<String> gender = ['Male', 'Female'];

  List<String> _roles = [
    'Office Staff',
    'Admin Team',
    'Dive Team',
    'Accounts Team',
    'Front Desk Team',
    'Marketing Team',
    'Captain Team',
    'Bookings Team',
    'Social Media',
    'Freelance Team',
  ];

  ///Switches

  bool? _viewBookings = false;
  bool? _weatherReport = false;
  bool? _createBookings = false;
  bool? _editBookings = false;
  bool? _personalAttendanceReport = false;
  bool? _editActivityPrices = false;
  bool? _addActivity = false;
  bool? _editEmployees = false;
  bool? _personalProfileEdit = false;
  bool? _attendanceReport = false;
  bool? _createEmployees = false;
  bool? _viewEmployees = false;
  bool? _notifications = false;

  bool? get notifications => _notifications;

  set notifications(bool? value) {
    _notifications = value;
    update();
  }

  bool? get viewBookings => _viewBookings;

  set viewBookings(bool? value) {
    _viewBookings = value;
    update();
  }

  String? _countryISoCOde = "IN";

  List<String> get roles => _roles;

  String? get countryISoCOde => _countryISoCOde;

  set countryISoCOde(String? value) {
    _countryISoCOde = value;
    update();
  }

  set roles(List<String> value) {
    _roles = value;
    update();
  }

  reset() {
    employeeIdTED.text = "";
    firstNameTED.text = "";
    lastNameTED.text = "";
    phoneNumberTED.text = "";
    countryCodeTED.text = "";
    roleTED.text = "";
    shiftTimeTED.text = "";
    genderTED.text = "";
    employeeIdTED.text = "";
    agencyIdTED.text = "";
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
    notifications = false;
  }

  bool? get createBookings => _createBookings;

  set createBookings(bool? value) {
    _createBookings = value;
    update();
  }

  bool? get editBookings => _editBookings;

  set editBookings(bool? value) {
    _editBookings = value;
    update();
  }

  bool? get viewEmployees => _viewEmployees;

  set viewEmployees(bool? value) {
    _viewEmployees = value;
    update();
  }

  bool? get createEmployees => _createEmployees;

  set createEmployees(bool? value) {
    _createEmployees = value;
    update();
  }

  bool? get editEmployees => _editEmployees;

  set editEmployees(bool? value) {
    _editEmployees = value;
    update();
  }

  bool? get personalProfileEdit => _personalProfileEdit;

  set personalProfileEdit(bool? value) {
    _personalProfileEdit = value;
    update();
  }

  bool? get personalAttendanceReport => _personalAttendanceReport;

  set personalAttendanceReport(bool? value) {
    _personalAttendanceReport = value;
    update();
  }

  bool? get attendanceReport => _attendanceReport;

  set attendanceReport(bool? value) {
    _attendanceReport = value;
    update();
  }

  bool? get weatherReport => _weatherReport;

  set weatherReport(bool? value) {
    _weatherReport = value;
    update();
  }

  bool? get editActivityPrices => _editActivityPrices;

  set editActivityPrices(bool? value) {
    _editActivityPrices = value;
    update();
  }

  bool? get addActivity => _addActivity;

  set addActivity(bool? value) {
    _addActivity = value;
    update();
  }
}

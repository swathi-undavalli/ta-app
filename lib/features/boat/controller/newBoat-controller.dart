import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/presentation/screens/boat-page.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class NewBoatLogic {
  NewBoatController controller = Get.put(NewBoatController());

  // NewBoatLogic() {
  //   this.getCount();
  //   this.getData();
  // }

  getCount() {
    controller.employeeCount = 0;
    controller.allEmployeesList = [];
    if (counterModel != null && counterModel.employee != null) {
      controller.employeeCount = counterModel.employee;
    }
    // return getData(counterModel.employee);
    // return 54;
    else {
      controller.employeeCount = 54;
    }
    print(controller.employeeCount);
  }

  getData() async {
    controller.allEmployeesList = [];
    for (int i = 1; i <= controller.employeeCount; i++) {
      var data = await FirebaseFirestore.instance
          .collection("employees")
          .doc(i.toString())
          .collection("employeeFullInformation")
          .doc("employeeData")
          .get();
      Map<String, dynamic> employeeData = data.data();
      var e = Employee.fromMap(employeeData);
      controller.allEmployeesList.add(e);
    }
    controller.showLoading = false;
    log(controller.employeeCount.toString());
    log("snjdnjsdnk ksd kxjs kns ksdf nk ");
    log(controller.allEmployeesList.length.toString());
  }

  onSubmit() async {
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("count")
        .get();
    CounterModel counterModel = CounterModel.fromMap(data.data());
    if (controller.boatNameTED.text != "" &&
        controller.boatCapacityTED.text != "" &&
        controller.captainNameTED.text != "" &&
        controller.phoneTED.text != "") {
      BoatsModel boatsModel = BoatsModel(
        boatName: controller.boatNameTED.text,
        capacity: int.parse(controller.boatCapacityTED.text),
        captainName: controller.captainNameTED.text,
        phoneNumber: controller.phoneTED.text,
        id: (counterModel.boat + 1).toString(),
      );
      FirebaseFirestore.instance
          .collection('boats')
          .doc(boatsModel.id)
          .set(boatsModel.toMap());
      counterModel.boat++;
      FirebaseFirestore.instance
          .collection("counter")
          .doc("count")
          .set(counterModel.toMap());
      Fluttertoast.showToast(msg: "Saved");
      disposeKeyboard();
      controller.reset();
      Get.back();
      BoatLogic boatLogic = BoatLogic();
      boatLogic.getData();
      BoatPage();
    } else {
      Fluttertoast.showToast(msg: "Invalid Input");
    }
  }
}

class NewBoatController extends GetxController {
  TextEditingController boatNameTED = TextEditingController();
  TextEditingController boatCapacityTED = TextEditingController();
  TextEditingController captainNameTED = TextEditingController();
  TextEditingController phoneTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();

  FocusNode boatNameNode = FocusNode();
  FocusNode boatCapacityNode = FocusNode();
  FocusNode captainNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();

  reset() {
    boatNameTED.text = "";
    boatCapacityTED.text = "";
    captainNameTED.text = "";
    phoneTED.text = "";
  }

  int _employeeCount;

  bool _showLoading = true;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  int get employeeCount => _employeeCount;

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

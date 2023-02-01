import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/repository/employee_repo.dart';
import 'package:temple_adventures/core/services/data_persistance.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class DashBoardScreenLogic {
  DashBoardScreenController controller = Get.find();

  DashBoardScreenLogic() {
    getCurrentEmployee();
    getCounterData();
    reloadAfter1Sec();
  }
  getCounterData() async {
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("count")
        .get();
    counterModel = CounterModel.fromMap(data.data()!);
    var count = counterModel!.employee;
    //print(count);
  }
  reloadAfter1Sec() {
    //log("reloadAfter1Sec");
    Future.delayed(Duration(seconds: 1))
        .whenComplete(() => controller.update());
  }

  getCurrentEmployee() async {
    controller.showLoading = true;
    if (currentEmployee == null) {
      currentEmployee = Employee();
      await EmployeeRepo.synchronise();
      controller.update();
    }
    controller.showLoading = false;
    controller.update();
  }
}

class DashBoardScreenController extends GetxController {
  int _currentIndex = 0;
  bool _showLoading = false;

  int get currentIndex => _currentIndex;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
  }

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }
}

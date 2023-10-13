import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/models/counter_model.dart';
import 'package:temple_adventures/core/repository/employee_repo.dart';
import 'package:temple_adventures/features/employees/model/employee.dart';

import '../../activities/model/colors_data.dart';

class DashBoardScreenLogic {
  DashBoardScreenController controller = Get.find();

  DashBoardScreenLogic() {
    getColorsData();
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
  }

  getColorsData() async {
    var data = await FirebaseFirestore.instance
        .collection("catalogue")
        .doc("colors")
        .get();
    colorsData = ColorsDataModel.fromMap(data.data() ?? {});
  }

  reloadAfter1Sec() {
    Future.delayed(Duration(seconds: 1))
        .whenComplete(() => controller.update());
  }

  getCurrentEmployee() async {
    controller.showLoading = true;
    if (currentEmployee == null) {
      await EmployeeRepo.synchronise();
      controller.update();
    }
    controller.showLoading = false;
    controller.update();
  }
}

class DashBoardScreenController extends GetxController {
  int _currentIndex = 0;
  bool showLoading = false;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }
}

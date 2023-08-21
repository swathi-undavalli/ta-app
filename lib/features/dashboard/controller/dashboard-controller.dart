import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/repository/employee_repo.dart';
import 'package:temple_adventures/core/models/counter-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import '../../home/model/colors_data.dart';

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
    var count = counterModel!.employee;
    //print(count);
  }

  getColorsData() async {
    var data = await FirebaseFirestore.instance
        .collection("catalogue")
        .doc("colors")
        .get();
    colorsData = ColorsDataModel.fromMap(data.data()!);
  }

  reloadAfter1Sec() {
    //log("reloadAfter1Sec");
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

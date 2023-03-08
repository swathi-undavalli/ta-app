import 'package:get/get.dart';

import '../screens/add-conditions-screen.dart';

class ConditionsLogic {
  ConditionsController controller = Get.put(ConditionsController());

  void onFloatingActionButtonPressed() {
    Get.toNamed(AddConditionsPage.id);
  }
}

class ConditionsController extends GetxController {
  DateTime selectedDate = DateTime.now();
}

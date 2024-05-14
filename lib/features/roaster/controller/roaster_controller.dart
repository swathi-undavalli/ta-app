import 'package:get/get.dart';

class RoasterLogic {
  RoasterController controller = Get.put(RoasterController());

  Future<void> onDateChanged(DateTime date) async {
    controller.selectedDate = date;
    controller.showLoading = true;
    controller.showLoading = false;
    controller.update();
  }
}

class RoasterController extends GetxController {
  DateTime selectedDate = DateTime.now();
  bool showLoading = false;
}

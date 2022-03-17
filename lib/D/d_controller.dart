import 'package:get/get.dart';

class DLogic {
  DController controller = Get.put(DController());
}

class DController extends GetxController {
  int _count = 0;

  int get count => _count;

  set count(int value) {
    _count = value;

    update();
  }
}

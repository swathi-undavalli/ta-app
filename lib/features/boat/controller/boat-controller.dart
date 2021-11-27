import 'package:get/get.dart';

class BoatLogic {
  BoatController controller = Get.put(BoatController());
}

class BoatController extends GetxController {
  List<bool> _isOpen = [false, false, false];
  List<String> _boats = ['BATMAN', 'LONGTAIL', 'KINGFISHER'];

  List<String> get boats => _boats;

  List<bool> get isOpen => _isOpen;

  set boats(List<String> value) {
    _boats = value;
    update();
  }

  set isOpen(List<bool> value) {
    _isOpen = value;
    update();
  }
}

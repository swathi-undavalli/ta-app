import 'package:get/get.dart';
import 'package:temple_adventures/features/conditions/repositories/conditions-repository.dart';
import '../models/conditions-model.dart';
import '../screens/add-conditions-screen.dart';

class ConditionsLogic {
  ConditionsController controller = Get.put(ConditionsController());
  ConditionsRepository conditionsRepo = ConditionsRepository();

  Future<void> init() async {
    controller.showLoading = true;
    controller.selectedDate = DateTime.now();
    await getLatestConditions();
    controller.showLoading = false;
  }

  Future<void> onDateChanged(DateTime date) async {
    controller.selectedDate = date;
    controller.showLoading = true;
    await getLatestConditions();
    controller.showLoading = false;
  }

  getLatestConditions() async {
    controller.conditions =
        await conditionsRepo.getConditions(controller.selectedDate);
  }

  void onFloatingActionButtonPressed() {
    Get.toNamed(AddConditionsScreen.id, arguments: controller.selectedReef);
  }

  List<Level> get getLevels {
    if (controller.conditions == null ||
        controller.conditions!.levels.isEmpty) {
      return [];
    }

    List<Level> levels = [];

    controller.conditions!.levels.forEach((element) {
      if (element.reef == controller.selectedReef) {
        levels.add(element);
      }
    });
    levels.sort((a, b) => a.depth.compareTo(b.depth));

    return levels;
  }

  onChipChanged(String reefName) {
    controller.selectedReef = reefName;
    controller.update();
  }
}

class ConditionsController extends GetxController {
  DateTime selectedDate = DateTime.now();
  late String selectedReef = reefs[0];
  bool _showLoading = true;
  Conditions? conditions;
  Conditions? conditionsViaReef;

  List<String> reefs = [
    "Shallow site area",
    "Northern Rocks area",
    "Wall area"
  ];

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}

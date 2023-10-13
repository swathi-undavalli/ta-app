import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/conditions/controller/conditions_controller.dart';
import 'package:temple_adventures/features/conditions/models/conditions_model.dart';
import 'package:temple_adventures/features/conditions/repositories/conditions_repository.dart';
import 'package:temple_adventures/features/employees/model/employee.dart';

class AddConditionsLogic {
  AddConditionsController controller = Get.put(AddConditionsController());
  ConditionsRepository conditionsRepo = ConditionsRepository();

  Future<void> init() async {
    log("calling init");
    log("==============================");
    controller.showLoading = true;
    await getExistingData();
    controller.showLoading = false;
  }

  getExistingData() async {
    log("calling existing data");

    controller.conditions = await conditionsRepo.getConditions(DateTime.now());

    if (controller.conditions == null) {
      controller.conditions = Conditions(
        id: getID(DateTime.now()),
        levels: [],
        surfaceConditions: List.generate(
            controller.reefs.length,
            (index) => SurfaceCondition(
                  reefName: controller.reefs[index],
                  temp: 20,
                  speed: 0,
                  currents: 0,
                  swell: 0,
                  updatedAt: DateTime.now(),
                  updatedBy: currentEmployee?.name ?? "-",
                )).toList(),
      );
    }
  }

  List<Level> get getLevels {
    log("calling get levels");

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

    return levels;
  }

  bool addLevel({
    required String depth,
    required String reefName,
  }) {
    log("calling add level");

    if (controller.conditions != null &&
        controller.conditions!.levels.isNotEmpty) {
      bool isAlreadyExist = false;
      for (int i = 0; i < controller.conditions!.levels.length; i++) {
        if (controller.conditions!.levels[i].depth == int.parse(depth) &&
            controller.conditions!.levels[i].reef == reefName) {
          isAlreadyExist = true;
        }
      }
      if (isAlreadyExist) return false;
    }

    controller.conditions!.levels.add(
      Level(
          depth: int.parse(depth),
          fish: 5,
          visibility: 5,
          currents: 0,
          updatedAt: DateTime.now(),
          reef: reefName,
          updatedBy: (currentEmployee != null) ? currentEmployee!.name : "-"),
    );
    log("=======================================");
    log(controller.conditions!.levels.toString());
    controller.update();
    return true;
  }

  Future<void> onSavePressed() async {
    log("on save pressed");

    controller.showLoading = true;

    await conditionsRepo.updateConditions(controller.conditions!);
    controller.showLoading = false;

    Get.back();
    ConditionsLogic conditionsLogic = ConditionsLogic();
    conditionsLogic.init();
  }

  String getID(DateTime date) => DateFormat("dd-M-yyyy").format(date);

  void onChipChanged(String e) {
    log("on chip changed");

    controller.selectedReef = e;
    controller.update();
  }
}

class AddConditionsController extends GetxController {
  Conditions? conditions;

  bool _showLoading = false;

  bool addLevel = true;

  double surfaceTemp = 20;
  double surfaceCurrents = 0;
  double windSpeed = 0;
  double swell = 0;

  late String selectedReef = reefs[0];

  // List<Level> levels = [];

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

  void reset() {
    conditions = null;
    surfaceTemp = 20;
    surfaceCurrents = 0;
    windSpeed = 0;
    swell = 0;
  }
}

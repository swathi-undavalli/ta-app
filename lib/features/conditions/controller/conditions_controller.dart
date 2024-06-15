import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/conditions_model.dart';
import '../presentation/views/add_conditions_view.dart';
import '../repositories/conditions_repository.dart';

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
    controller.conditions = await conditionsRepo.getConditions(controller.selectedDate);
  }

  void onFloatingActionButtonPressed(BuildContext context) {
    Navigator.push(context, AddConditionsView.route());
  }

  List<Level> get getLevels {
    if (controller.conditions == null || controller.conditions!.levels.isEmpty) {
      return [];
    }

    List<Level> levels = [];

    for (var element in controller.conditions!.levels) {
      if (element.reef == controller.selectedReef) {
        levels.add(element);
      }
    }
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

  List<String> reefs = ['Shallow site area', 'Northern Rocks area', 'Wall area'];

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}

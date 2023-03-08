import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddConditionsLogic {
  AddConditionsController controller = Get.put(AddConditionsController());
}

class AddConditionsController extends GetxController {
  TextEditingController depth = TextEditingController();

  List<String> allDepths = [];

  void reset() {
    depth.text = "";
    allDepths = [];
  }
}

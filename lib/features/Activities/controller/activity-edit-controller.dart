import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityEditLogic {
  ActivityEditController controller = Get.put(ActivityEditController());
}

class ActivityEditController extends GetxController {
  TextEditingController priceTED = TextEditingController();
  TextEditingController nameTED = TextEditingController();
  TextEditingController colorTED = TextEditingController();

  List<String> colorCode = ['Blue', 'Green', 'Purple', 'Red', 'White'];

  reset() {
    priceTED.text = "";
    colorTED.text = "";
    nameTED.text = "";
  }
}

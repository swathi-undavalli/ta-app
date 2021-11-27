import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityEditLogic {
  ActivityEditController controller = Get.put(ActivityEditController());
}

class ActivityEditController extends GetxController {
  TextEditingController priceTED = TextEditingController();
  TextEditingController nameTED = TextEditingController();

  reset() {
    priceTED.text = "";
    nameTED.text = "";
  }
}

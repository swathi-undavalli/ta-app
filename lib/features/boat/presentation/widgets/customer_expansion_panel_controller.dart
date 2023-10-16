import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerExpansionPanelLogic {
  CustomerExpansionPanelController controller =
  Get.put(CustomerExpansionPanelController());

  void onBookingStatusRightArrowPressed() {
    if (controller.customerStatus < 4) {
      controller.customerStatus += 1;
    }
  }

  void onBookingStatusLeftArrowPressed() {
    if (controller.customerStatus > 0 && controller.customerStatus <= 4) {
      controller.customerStatus -= 1;
    }
  }
}

class CustomerExpansionPanelController extends GetxController {
  TextEditingController customTED = TextEditingController();
  List<bool> isExpanded = [];
  int customerStatus = 0;
}

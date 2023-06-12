import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerExpansionPanelLogic {
  CustomerExpansionPanelController controller =
  Get.put(CustomerExpansionPanelController());

  void onBookingStatusRightArrowPressed() {
    if (controller.customerStatus < 4) {
      controller.customerStatus += 1;
      print(controller.customerStatus);
    }
  }

  void onBookingStatusLeftArrowPressed() {
    if (controller.customerStatus > 0 && controller.customerStatus <= 4) {
      controller.customerStatus -= 1;
      print(controller.customerStatus);
    }
  }
}

class CustomerExpansionPanelController extends GetxController {
  TextEditingController customTED = TextEditingController();
  List<bool> isExpanded = [];
  int customerStatus = 0;
  TextEditingController boatTED = TextEditingController();
  List<String> allBoats = [
    "Tucy",
    "007",
    "Batman",
    "Ranga",
    "Traveller",
    "Class Room",
  ];
  List<String> bookingStatus = [
    "Booking Done",
    "Paper work",
    "Pool Session",
    "Dive Session",
    "Left Dive Center"
  ];
}

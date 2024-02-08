import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../boat/models/boat_details.dart';

class AddLogLogic {
  AddLogController controller = Get.put(AddLogController());
}

class AddLogController extends GetxController {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  List<Instructor> instructor = [];
  TextEditingController courseTED = TextEditingController();
  TextEditingController diveSiteTED = TextEditingController();
  TextEditingController tankNoTED = TextEditingController();
  TextEditingController bottomTimeTED = TextEditingController();
  TextEditingController maxDepthTED = TextEditingController();
}

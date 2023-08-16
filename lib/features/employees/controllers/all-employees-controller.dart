import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AllEmployeesLogic {
  AllEmployeesController controller = Get.put(AllEmployeesController());
}

class AllEmployeesController extends GetxController {
  TextEditingController searchTED = TextEditingController();
}

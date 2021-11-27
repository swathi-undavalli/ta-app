import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/attendance_widget/attandence_persistence_model.dart';
import 'package:temple_adventures/core/services/data_persistance.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class HomePageLogic {
  HomePageController controller = Get.put(HomePageController());
}

class HomePageController extends GetxController {
}


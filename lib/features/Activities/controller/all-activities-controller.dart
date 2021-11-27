import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';

class AllActivitiesLogic {
  AllActivitiesController controller = Get.put(AllActivitiesController());

  AllActivitiesLogic() {
    this.getAllActivities();
  }

  getAllActivities() async {
    var data = await FirebaseFirestore.instance.collection("catalogue").get();
    controller.allActivitiesList = [];
    data.docs.forEach((element) {
      ActivityModel activity = ActivityModel.fromMap(element.data());
      controller.allActivitiesList.add(activity);
    });
    controller.showLoading = false;
  }
}

class AllActivitiesController extends GetxController {


  List<ActivityModel> allActivitiesList = [];

  bool _showLoading = true;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}

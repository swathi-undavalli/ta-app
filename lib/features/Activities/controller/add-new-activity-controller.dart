import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/Activities/controller/activity-edit-controller.dart';
import 'package:temple_adventures/features/Activities/controller/all-activities-controller.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

import '../../counter-model.dart';

class AddNewActivityLogic {
  AddNewActivityController controller = Get.put(AddNewActivityController());

  AllActivitiesLogic allActivitiesLogic = AllActivitiesLogic();

  onSubmit() async {
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("count")
        .get();
    CounterModel counterModel = CounterModel.fromMap(data.data()!);

    if (controller.nameTED.text != "" &&
        controller.priceTED.text != "" &&
        controller.priorityTED.text != "" &&
        controller.colorTED.text != "") {
      ActivityModel activityModel = ActivityModel(
          name: controller.nameTED.text,
          price: int.parse(controller.priceTED.text),
          priority: int.parse(controller.priorityTED.text),
          color: controller.colorTED.text,
          id: (counterModel.activity! + 1).toString());

      FirebaseFirestore.instance
          .collection('catalogue')
          .doc(activityModel.id)
          .set(activityModel.toMap());
      if (counterModel.activity != null) {
        counterModel.activity = counterModel.activity! + 1;
      }
      FirebaseFirestore.instance
          .collection("counter")
          .doc("count")
          .set(counterModel.toMap());
      LogModel logModel =
          LogModel(type: LogType.addActivity, activityName: activityModel.name);
      FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());
      Fluttertoast.showToast(msg: "Saved");
      disposeKeyboard();
      controller.reset();
      Get.back();
      allActivitiesLogic.getAllActivities();
    }
  }
}

class AddNewActivityController extends GetxController {
  TextEditingController nameTED = TextEditingController();
  TextEditingController priceTED = TextEditingController();
  TextEditingController priorityTED = TextEditingController();
  TextEditingController colorTED = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode priorityNode = FocusNode();
  FocusNode colorNode = FocusNode();

  reset() {
    nameTED.text = "";
    priceTED.text = "";
    priorityTED.text = "";
    colorTED.text = "";
  }

  List<String> priority = ['0', '1'];

  List<String> colorCode = ['Blue', 'Green', 'Purple', 'Red', 'White'];
}

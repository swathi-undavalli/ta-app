import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';

class AddNewActivityLogic {
  AddNewActivityController controller = Get.put(AddNewActivityController());

  onSubmit() async {
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("activity")
        .get();
    Map<String, dynamic> activityCount = data.data();
    var totalCount = activityCount["count"];
    if (controller.nameTED.text != "" &&
        controller.priceTED.text != "" &&
        controller.priorityTED.text != "" &&
        controller.colorTED.text != "") {
      ActivityModel activityModel = ActivityModel(
          name: controller.nameTED.text,
          price: int.parse(controller.priceTED.text),
          priority: int.parse(controller.priorityTED.text),
          color: controller.colorTED.text,
          id: (totalCount + 1).toString());
      FirebaseFirestore.instance
          .collection('catalogue')
          .doc(activityModel.id)
          .set(activityModel.toMap());
      FirebaseFirestore.instance
          .collection("counter")
          .doc("activity")
          .set({"count": totalCount + 1});
      Fluttertoast.showToast(msg: "Saved");
      disposeKeyboard();
      controller.reset();
      Get.back();
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

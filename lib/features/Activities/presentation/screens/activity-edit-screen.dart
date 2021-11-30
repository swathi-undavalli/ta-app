import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/Activities/controller/activity-edit-controller.dart';
import 'package:temple_adventures/features/Activities/controller/all-activities-controller.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class ActivityEditScreen extends StatelessWidget {
  static const String id = "PriceEditScreen";
  final ActivityModel activityArg = Get.arguments;
  ActivityEditLogic logic = ActivityEditLogic();
  AllActivitiesLogic allActivitiesLogic = AllActivitiesLogic();
  ActivityEditScreen() {
    logic.controller.priceTED.text = activityArg.price.toString();
    logic.controller.nameTED.text = activityArg.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: GetBuilder<ActivityEditController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GetBuilder<ActivityEditController>(builder: (controller) {
              return Column(
                children: [
                  SizedBox(height: 50),
                  buildTextFields(
                      name: "Activity Name",
                      textEditingController: controller.nameTED,
                      keyBoardType: TextInputType.name),
                  buildTextFields(
                      name: "Price",
                      textEditingController: controller.priceTED,
                      keyBoardType: TextInputType.number),
                  SizedBox(height: 100),
                  buildButtons()
                ],
              );
            }),
          );
        }),
      ),
    );
  }

  Widget buildButtons() {
    return GetBuilder<ActivityEditController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton.flat(
            height: 45,
            width: 140,
            color: AppColors.background.grey,
            text: "Cancel",
            textColor: AppColors.text.black,
            onTap: () {
              Get.back();
              disposeKeyboard();
            },
          ),
          AppButton.flat(
              height: 45,
              width: 140,
              color: AppColors.background.black,
              text: "Update",
              textColor: AppColors.text.white,
              onTap: () async {
                activityArg.name = controller.nameTED.text;
                activityArg.price = int.parse(controller.priceTED.text);
                await FirebaseFirestore.instance
                    .collection("catalogue")
                    .doc(activityArg.id)
                    .set(activityArg.toMap());
                Get.back();
                controller.reset();
                allActivitiesLogic.controller.allActivitiesList = [];
                allActivitiesLogic.controller.update();
                allActivitiesLogic.getAllActivities();
              }),
        ],
      );
    });
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTitle() {
    return Text(
      'Edit Activity',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildTextFields(
      {String name,
      TextEditingController textEditingController,
      TextInputType keyBoardType}) {
    return Container(
      width: 320,
      child: AppTextField(
        hintText: name,
        controller: textEditingController,
        keyboardType: keyBoardType,
        errorValidator: () {
          return null;
        },
        validator: (_) {
          return null;
        },
      ),
    );
  }
}

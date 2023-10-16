import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/back_navigation_icon.dart';
import '../../../bookings/models/activity_model.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../../logs/models/log_model.dart';
import '../../../logs/presentation/screens/log_screen.dart';
import '../../controller/activity_edit_controller.dart';
import '../../controller/all_activities_controller.dart';
import '../../model/colors_data.dart';

// ignore: must_be_immutable
class ActivityEditScreen extends StatelessWidget {
  static const String id = 'PriceEditScreen';
  final Activity? activityArg = Get.arguments;
  final ActivityEditLogic logic = ActivityEditLogic();
  final AllActivitiesLogic allActivitiesLogic = AllActivitiesLogic();

  ActivityEditScreen({Key? key}) : super(key: key) {
    logic.controller.priceTED.text = activityArg!.price.toString();
    logic.controller.nameTED.text = activityArg!.name!;
    logic.controller.shortNameTED.text = activityArg?.shortName ?? '';
    logic.controller.colorTED.text = activityArg!.color!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: SafeArea(
        child: GetBuilder<ActivityEditController>(
          builder: (controller) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<ActivityEditController>(
                  builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(activityArg.id),
                        const SizedBox(height: 50),
                        buildTextFields(
                          name: 'Activity Name',
                          textEditingController: controller.nameTED,
                          keyBoardType: TextInputType.name,
                        ),
                        buildTextFields(
                          name: 'Short Name',
                          textEditingController: controller.shortNameTED,
                          keyBoardType: TextInputType.text,
                        ),
                        buildTextFields(
                          name: 'Price',
                          textEditingController: controller.priceTED,
                          keyBoardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        buildSubtitle('Color'),
                        buildColorCode(),
                        const SizedBox(height: 100),
                        buildButtons()
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSubtitle(String name) {
    return SizedBox(
      width: Get.size.width,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.black54,
          fontFamily: AppFonts.nunito,
          fontSize: 10,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget buildColorCode() {
    return GetBuilder<ActivityEditController>(
      builder: (controller) {
        return DropdownButton(
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.colorTED.text.isNotEmpty ? controller.colorTED.text : null,
          onChanged: (dynamic newColor) {
            controller.colorTED.text = newColor;
            controller.update();
          },
          items: controller.colorCode.map((color) {
            return DropdownMenuItem(
              value: color,
              child: Text(color),
            );
          }).toList(),
        );
      },
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
              text: 'Cancel',
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
              text: 'Update',
              textColor: AppColors.text.white,
              onTap: () async {
                activityArg!.name = controller.nameTED.text;
                activityArg!.shortName = controller.shortNameTED.text;
                activityArg!.price = int.parse(controller.priceTED.text);
                activityArg!.color = controller.colorTED.text;
                await FirebaseFirestore.instance.collection('catalogue').doc(activityArg!.id).set(activityArg!.toMap());

                await updateColorsDocument();

                LogModel logModel = LogModel(
                  type: LogType.editActivity,
                  activityName: activityArg!.name,
                );
                FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());

                Get.back();
                controller.reset();
                allActivitiesLogic.controller.allActivitiesList = [];
                allActivitiesLogic.controller.update();
                allActivitiesLogic.getAllActivities();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: const BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Spacer(),
        Text(
          'Edit Activity',
          style: TextStyle(
            color: AppColors.text.black,
            fontSize: 20,
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Get.defaultDialog(
              contentPadding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
              title: '\nAre You Sure ? ',
              middleText: 'Activity will Be Deleted Permanently.',
              backgroundColor: Colors.white,
              titleStyle: TextStyle(
                color: AppColors.text.black,
                fontFamily: AppFonts.nunito,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              middleTextStyle: TextStyle(
                color: AppColors.text.black,
                fontFamily: AppFonts.nunito,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              confirm: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton.miniText(
                    text: 'Cancel',
                    onTap: () {
                      Get.back();
                    },
                  ),
                  AppButton.miniFlat(
                    text: 'OK',
                    onTap: () {
                      FirebaseFirestore.instance.collection('catalogue').doc(activityArg!.id).delete();
                      Get.back();
                      Get.back();
                      allActivitiesLogic.controller.update();
                      allActivitiesLogic.getAllActivities();
                    },
                  ),
                ],
              ),
              barrierDismissible: false,
              radius: 10,
            );
          },
          child: const Icon(
            Icons.delete,
            size: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 20)
      ],
    );
  }

  Widget buildTextFields({
    String? name,
    TextEditingController? textEditingController,
    TextInputType? keyBoardType,
  }) {
    return SizedBox(
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

  Future<void> updateColorsDocument() async {
    var data = await FirebaseFirestore.instance.collection('catalogue').get();
    var map = {
      'Blue': [],
      'Purple': [],
      'White': [],
      'Red': [],
      'Green': [],
    };

    for (var d in data.docs) {
      if (d.id == 'colors') continue;
      var color = d.data()['color'];
      var name = d.data()['name'];
      map[color]!.add(name);
    }

    await FirebaseFirestore.instance.collection('catalogue').doc('colors').set(map);

    colorsData = ColorsDataModel.fromMap(map);
  }
}

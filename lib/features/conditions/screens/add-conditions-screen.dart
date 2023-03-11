import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/conditions/models/conditions-model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import '../controller/add-conditions-controller.dart';
import 'package:intl/intl.dart';
import '../widgets/depth-expansion-panel-widget.dart';
import '../widgets/surface-conditions-expansion-panel.dart';

class AddConditionsScreen extends StatelessWidget {
  final AddConditionsLogic logic = AddConditionsLogic();
  final TextEditingController depthTED = TextEditingController();

  static const String id = "AddConditionsPage";

  AddConditionsScreen() {
    logic.init();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddConditionsController>(builder: (controller) {
      return Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              if (logic.controller.conditions != null &&
                  logic.controller.conditions!.levels.isNotEmpty)
                _showAlert(
                    context: context,
                    content: "All your changes will be discarded.",
                    title: 'Are you sure,you want to go back?',
                    onOkayPressed: () {
                      logic.controller.reset();
                      Get.back();
                      Get.back();
                    });
              else {
                logic.controller.reset();
                Get.back();
              }
              return true;
            },
            child: Scaffold(
              appBar: buildAppBar(context) as PreferredSizeWidget?,
              floatingActionButton: buildFloatingActionButton(),
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Container(
                        width: 103,
                        child: Text(
                          DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ).paddingSymmetric(horizontal: 30),
                      SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          ...controller.reefs.map(
                            (e) => buildChip(
                              onTap: () {
                                logic.onChipChanged(e);
                              },
                              reefName: e,
                            ),
                          )
                        ]).paddingSymmetric(horizontal: 27),
                      ),
                      SizedBox(height: 30),
                      if (controller.conditions != null)
                        SurfaceConditionsExpansionWidget(
                          key: UniqueKey(),
                          surfaceConditions:
                              controller.conditions!.surfaceConditions,
                          onChanged:
                              (List<SurfaceCondition> surfaceConditions) {
                            controller.conditions = controller.conditions!
                                .copyWith(surfaceConditions: surfaceConditions);
                          },
                          selectedReef: controller.selectedReef,
                          disableTouches: false,
                        ).paddingSymmetric(horizontal: 27),
                      SizedBox(height: 30),
                      if (controller.conditions != null &&
                          controller.conditions!.levels.isNotEmpty)
                        Text(
                          "Water Conditions : ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ).paddingSymmetric(horizontal: 27),
                      if (logic.getLevels.isEmpty)
                        Container(
                            height: Get.height / 3,
                            width: Get.width,
                            child: Center(
                                child: Text(
                                    "Please add water conditions by clicking below"))),
                      SizedBox(height: 30),
                      if (controller.conditions != null &&
                          controller.conditions!.levels.isNotEmpty)
                        ...controller.conditions!.levels.asMap().entries.map(
                          (l) {
                            if (l.value.reef == controller.selectedReef)
                              return DepthExpansionPanelWidget(
                                level: l.value,
                                onDeletePressed: () {
                                  _showAlert(
                                      context: context,
                                      title: "Are you you want to delete ?",
                                      content:
                                          "Added information will be completely removed.",
                                      onOkayPressed: () {
                                        controller.conditions!.levels
                                            .removeAt(l.key);
                                        Get.back();
                                        // log(controller.conditions.toString());
                                        controller.update();
                                      });
                                },
                                onChanged: (double fish, double visibility,
                                    double currents) {
                                  controller.conditions!.levels[l.key] =
                                      controller.conditions!.levels[l.key]
                                          .copyWith(
                                    fish: fish.toInt(),
                                    visibility: visibility.toInt(),
                                    currents: currents.toInt(),
                                  );

                                  // log("$fish");
                                  // log("$visibility");
                                  // log("$currents");
                                },
                              ).paddingOnly(bottom: 12, left: 27, right: 27);
                            return SizedBox();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (controller.showLoading)
            Container(
              color: Colors.white.withOpacity(0.6),
              height: Get.height,
              width: Get.width,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
        ],
      );
    });
  }

  ///=====================UI==================///

  Widget buildChip({required Function onTap, required String reefName}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: logic.controller.selectedReef == reefName
              ? AppColors.text.skyBlue
              : AppColors.text.white,
        ),
        child: Text(
          reefName,
          style: TextStyle(
              color: logic.controller.selectedReef == reefName
                  ? AppColors.text.white
                  : AppColors.text.black,
              fontSize: FontSize.small),
        ).paddingSymmetric(horizontal: 9, vertical: 5),
      ).paddingOnly(right: 13),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      toolbarHeight: 70,
      leading: IconButton(
        color: AppColors.text.black,
        iconSize: 17,
        onPressed: () {
          _showAlert(
              context: context,
              content: "All your changes will be discarded.",
              title: 'Are you sure,you want to go back?',
              onOkayPressed: () {
                logic.controller.reset();
                Get.back();
                Get.back();
              });
        },
        icon: Icon(Icons.arrow_back_ios),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            logic.onSavePressed();
          },
          child: Center(
            child: Container(
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.black),
              child: Center(
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: FontSize.small),
                ),
              ),
            ).paddingOnly(right: 30),
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _showAlert(
      {required BuildContext context,
      required String title,
      required String content,
      required Function onOkayPressed}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: Text(
              content,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            actions: <Widget>[
              Row(
                children: [
                  AppButton.miniText(
                    text: "Cancel",
                    onTap: () {
                      Get.back();
                    },
                  ),
                  Spacer(),
                  AppButton.miniFlat(
                    text: "Okay",
                    onTap: () {
                      onOkayPressed();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ],
          );
        });
  }

  Widget buildFloatingActionButton() {
    return GetBuilder<AddConditionsController>(builder: (controller) {
      return FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
        onPressed: () {
          Get.bottomSheet(
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Depth",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  AppTextField(
                    hintText: "Add depth",
                    controller: depthTED,
                    keyboardType: TextInputType.number,
                    errorValidator: () {
                      return null;
                    },
                    validator: (firstName) {
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      AppButton.miniText(
                        text: "Cancel",
                        onTap: () {
                          Get.back();
                          depthTED.clear();
                        },
                      ),
                      Spacer(),
                      AppButton.miniFlat(
                        text: "Submit",
                        onTap: () {
                          if (logic.addLevel(
                            depth: depthTED.text,
                            reefName: controller.selectedReef,
                          )) {
                            depthTED.clear();
                            Get.back();
                          } else {
                            showToast("Depth is already added in this site");
                          }
                        },
                        textColor: AppColors.text.white,
                      ),
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 30, vertical: 30),
            ),
            barrierColor: Colors.black.withOpacity(0.3),
            isDismissible: false,
          );
        },
      );
    });
  }
}

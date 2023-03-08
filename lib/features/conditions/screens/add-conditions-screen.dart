import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import '../controller/add-conditions-controller.dart';
import '../widgets/depth-expansion-panel-widget.dart';

class AddConditionsPage extends StatelessWidget {
  final AddConditionsLogic logic = AddConditionsLogic();
  static const String id = "AddConditionsPage";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddConditionsController>(builder: (controller) {
      return Scaffold(
        appBar: buildAppBar(context) as PreferredSizeWidget?,
        floatingActionButton: buildFloatingActionButton(),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 30),
              if (controller.allDepths.isEmpty)
                Container(
                    height: Get.height / 2,
                    width: Get.width,
                    child: Center(
                        child: Text(
                            "Please add water conditions by clicking below"))),
              ...controller.allDepths.map(
                (e) => DepthExpansionPanelWidget(
                  depth: e,
                  onDeletePressed: () {
                    _alert(
                        context: context,
                        title: "Are you you want to delete ?",
                        content:
                            "Added information will be completely removed.",
                        onOkayPressed: () {
                          controller.allDepths.remove(e);
                          Get.back();
                          log(controller.allDepths.toString());
                          controller.update();
                        });
                  },
                  onChanged: (int fish, int visibility, int currents) {
                    log("$fish");
                    log("$visibility");
                    log("$currents");
                  },
                ).paddingOnly(bottom: 12, left: 27, right: 27),
              ),
            ],
          ),
        )),
      );
    });
  }

  ///=====================UI==================///

  Widget buildAppBar(context) {
    return AppBar(
      toolbarHeight: 70,
      leading: GestureDetector(
          onTap: () {
            if (logic.controller.allDepths.isNotEmpty)
              _alert(
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
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          )),
      actions: [
        if (logic.controller.allDepths.isNotEmpty)
          GestureDetector(
            onTap: () {},
            child: Center(
              child: Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
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

  Future<void> _alert(
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
                  controller: logic.controller.depth,
                  keyboardType: TextInputType.number,
                  errorValidator: () {
                    return null;
                  },
                  validator: (firstName) {
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    AppButton.miniText(
                      text: "Cancel",
                      onTap: () {
                        Get.back();
                        logic.controller.depth.text = "";
                      },
                    ),
                    Spacer(),
                    AppButton.miniFlat(
                      text: "Submit",
                      onTap: () {
                        logic.controller.allDepths
                            .add(logic.controller.depth.text);
                        logic.controller.depth.text = "";
                        logic.controller.update();
                        Get.back();
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
  }

  Widget buildSubmitCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton.flat(
          text: "Cancel",
          onTap: () {
            Get.back();
          },
          textColor: AppColors.text.black,
        ),
        AppButton.flat(
          text: "Submit",
          onTap: () {},
          color: AppColors.background.black,
          textColor: AppColors.text.white,
        ),
      ],
    );
  }
}

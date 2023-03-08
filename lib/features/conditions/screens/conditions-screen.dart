import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';

import '../controller/conditions-controller.dart';

class ConditionsScreen extends StatelessWidget {
  final ConditionsLogic logic = ConditionsLogic();
  final now = DateTime.now();

  ConditionsScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          logic.onFloatingActionButtonPressed();
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        color: AppColors.IconColor.black,
        onRefresh: () async {},
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                GetBuilder<ConditionsController>(builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 103,
                            child: Text(
                              DateFormat('dd-MMM-yyyy').format(controller.selectedDate),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              // selectDate(context);
                            },
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 17,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 32),
                      SizedBox(height: 20),
                      Container(
                        width: Get.width,
                        height: 389,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ).paddingSymmetric(horizontal: 27),
                      SizedBox(height: 22),
                      Text(
                        "Surface Temperature : 30° C",
                        style: TextStyle(fontSize: FontSize.textSize, fontWeight: FontWeight.bold),
                      ).paddingSymmetric(horizontal: 27),
                      SizedBox(height: 34),
                      Row(
                        children: [
                          buildChip(onTap: () {}, reefName: "Temple Reef"),
                          buildChip(onTap: () {}, reefName: "Artificial Reef"),
                          buildChip(onTap: () {}, reefName: "Lake"),
                        ],
                      ).paddingSymmetric(horizontal: 27),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChip({required Function onTap, required String reefName}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 27,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: AppColors.text.skyBlue),
        child: Text(
          reefName,
          style: TextStyle(color: Colors.white, fontSize: FontSize.small),
        ).paddingSymmetric(horizontal: 9, vertical: 5),
      ).paddingOnly(right: 13),
    );
  }
}

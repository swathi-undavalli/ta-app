import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boatWidget.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';

class BoatPage extends StatelessWidget {
  final BoatLogic logic = BoatLogic();
  final now = DateTime.now();

  BoatPage() {
    logic.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.IconColor.black,
        onRefresh: () async {
          await logic.init();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                GetBuilder<BoatController>(builder: (controller) {
                  if (controller.showLoading)
                    return SizedBox(
                        height: Get.height - 100,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )));
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Coast Guard Slips',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 103,
                            child: Text(
                              DateFormat('dd-MMM-yyyy')
                                  .format(controller.selectedDate),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              selectDate(context);
                            },
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 22),
                      if (controller.noDataFound)
                        SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "No Boats Found",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "😔",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...List.generate(
                          controller.timeList.length,
                          (i) => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      color: AppColors.text.skyBlue,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      // left: 20,
                                      right: 100,
                                    ),
                                    child: Text(
                                      DateFormat('hh : mm')
                                          .format(controller.timeList[i]),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  AppButton.miniFlat(
                                    text: "View Slip",
                                    onTap: () {
                                      log("on slip pressed");
                                      logic.getSlip(
                                          boatPassengersModel:
                                              controller.bookedPassengers[i],
                                          time: controller.timeList[i]);
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ...List.generate(controller.boatsList.length,
                                  (index) {
                                return BoatWidget(
                                  boat: controller.boatsList[index],
                                  boatPassengersModel:
                                      controller.bookedPassengers[i],
                                );
                              }),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 50),
                    ],
                  ).paddingSymmetric(horizontal: 22);
                }),
                Container(
                  height: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///================UI=============///

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
      'CoastGuardSlips',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: logic.controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.text.black,
                textStyle:
                    TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      logic.controller.selectedDate = date;
      logic.controller.showLoading = true;
      await logic.getData();
      logic.controller.showLoading = false;
    }
  }
}

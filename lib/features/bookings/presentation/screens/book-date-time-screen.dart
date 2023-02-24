import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:intl/intl.dart';

import '../../models/activity-model.dart';

class BookDateTime extends StatelessWidget {
  static const String id = "BookDate&Time";
  final NewBookingLogic logic = NewBookingLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              SizedBox(height: 20),
              buildActivityDropDown(),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Dates",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.message,
                    color: AppColors.text.skyBlue,
                  ),
                ),
              ),
              SizedBox(height: 30),
              buildTheorySession(),
              SizedBox(height: 30),
              buildPoolSession(),
              SizedBox(height: 30),
              buildDiveSession(),
              Spacer(),
              buildContinueButton(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  ///==================UI=================///

  Widget buildActivityDropDown() {
    return Container(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 12),
              child: Container(
                width: Get.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle("Activities"),
              ),
            ),
          ),
          Container(
            width: 215,
            child: GetBuilder<NewBookingController>(builder: (controller) {
              return Padding(
                padding: const EdgeInsets.only(left: 13),
                child: DropdownButton(
                  underline: Container(height: 1, color: Colors.black45),
                  isExpanded: true,
                  value: controller.selectedActivity,
                  onChanged: (ActivityModel? activity) {
                    if (activity != null) {
                      controller.selectedActivity = activity;
                      controller.priceTED.text = activity.price.toString();
                      controller.bookingModel.price =
                          (activity.price ?? 0) * 1.0;
                      controller.bookingModel.activity = [activity];
                      logic.controller.update();
                    }
                  },
                  items: controller.activities.toSet().toList().map((activity) {
                    return DropdownMenuItem(
                      child: Text(
                        activity.name ?? "error",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      value: activity,
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildPoolSession() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pool Session",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: FontSize.textSize),
              ),
              AppButton.miniFlat(
                text: "ADD",
                onTap: () {
                  logic.addPoolSessionDateTime();
                },
                bgColor: AppColors.background.black,
                textColor: AppColors.text.white,
              )
            ],
          ),
          Wrap(
            children: (controller.bookingModel.poolDate ?? [])
                .map((e) => buildTime(e, DateType.Pool))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget buildDiveSession() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dive Session",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: FontSize.textSize),
              ),
              AppButton.miniFlat(
                text: "ADD",
                onTap: () {
                  logic.addDiveSessionDateTime();
                },
                bgColor: AppColors.background.black,
                textColor: AppColors.text.white,
              )
            ],
          ),
          Wrap(
            children: (controller.bookingModel.diveDate ?? [])
                .map((e) => buildTime(e, DateType.Dive))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget buildTheorySession() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Theory Session",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: FontSize.textSize),
              ),
              AppButton.miniFlat(
                text: "ADD",
                onTap: () {
                  logic.addTheorySessionDateTime();
                },
                bgColor: AppColors.background.black,
                textColor: AppColors.text.white,
              )
            ],
          ),
          Wrap(
            children: (controller.bookingModel.theoryDate ?? [])
                .map((e) => buildTime(e, DateType.Theory))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget buildTime(DateTime? date, DateType type) {
    if (date != null)
      return GestureDetector(
        onTap: () {
          if (type == DateType.Theory)
            logic.controller.bookingModel.theoryDate!.remove(date);
          if (type == DateType.Dive)
            logic.controller.bookingModel.diveDate!.remove(date);
          if (type == DateType.Pool)
            logic.controller.bookingModel.poolDate!.remove(date);
          logic.controller.update();
        },
        child: Container(
          width: 170,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.background.lightSkyBlue,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat("MMM  dd @ hh:mm a").format(date)),
              Icon(
                Icons.close,
                size: 16,
              ),
            ],
          ),
        ),
      );
    return SizedBox();
  }

  Widget buildContinueButton() {
    return Center(
      child: AppButton.flat(
        text: "Continue",
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: logic.onContinueChooseDatesPressed,
      ),
    );
  }

  Widget buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildSubTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 14,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle("Choose Date and Time"),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}

enum DateType {
  Theory,
  Pool,
  Dive,
}

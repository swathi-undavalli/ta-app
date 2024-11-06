import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controller/new_booking_controller.dart';
import '../../models/activity_model.dart';

class BookDateTimeView extends StatelessWidget {
  final NewBookingLogic logic = NewBookingLogic();

  BookDateTimeView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => BookDateTimeView(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Choose Date and Time'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              Spacing.h20,
              buildActivityDropDown(),
              Spacing.h30,
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add Dates',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.message,
                    color: AppColors.text.skyBlue,
                  ),
                ),
              ),
              Spacing.h30,
              buildTheorySession(context),
              Spacing.h30,
              buildPoolSession(context),
              Spacing.h30,
              buildDiveSession(context),
              const Spacer(),
              buildContinueButton(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  ///==================UI=================///

  Widget buildActivityDropDown() {
    return SizedBox(
      width: 320,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 12),
              child: Container(
                width: Screen.width,
                alignment: Alignment.centerLeft,
                child: buildSubTitle('Activities'),
              ),
            ),
          ),
          SizedBox(
            width: 215,
            child: GetBuilder<NewBookingController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: DropdownButton(
                    underline: Container(height: 1, color: Colors.black45),
                    isExpanded: true,
                    value: controller.selectedActivity,
                    dropdownColor: Colors.white,
                    onChanged: (Activity? activity) {
                      if (activity != null) {
                        controller.selectedActivity = activity;
                        controller.priceTED.text = activity.price.toString();
                        controller.bookingModel.price = (activity.price ?? 0) * 1.0;
                        controller.bookingModel.activity = [activity];
                        logic.controller.update();
                      }
                    },
                    items: controller.activities.toSet().toList().map((activity) {
                      return DropdownMenuItem(
                        value: activity,
                        child: Text(
                          activity.name ?? 'error',
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPoolSession(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pool Session',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.textSize,
                  ),
                ),
                AppButton.miniFlat(
                  text: 'ADD',
                  onTap: () {
                    logic.addPoolSessionDateTime(context);
                  },
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                ),
              ],
            ),
            Wrap(
              children: (controller.bookingModel.poolDate ?? []).map((e) => buildTime(e, DateType.pool)).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildDiveSession(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dive Session',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.textSize,
                  ),
                ),
                AppButton.miniFlat(
                  text: 'ADD',
                  onTap: () {
                    logic.addDiveSessionDateTime(context);
                  },
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                ),
              ],
            ),
            Wrap(
              children: (controller.bookingModel.diveDate ?? []).map((e) => buildTime(e, DateType.dive)).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildTheorySession(BuildContext context) {
    return GetBuilder<NewBookingController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Theory Session',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.textSize,
                  ),
                ),
                AppButton.miniFlat(
                  text: 'ADD',
                  onTap: () {
                    logic.addTheorySessionDateTime(context);
                  },
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                ),
              ],
            ),
            Wrap(
              children: (controller.bookingModel.theoryDate ?? []).map((e) => buildTime(e, DateType.theory)).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildTime(DateTime? date, DateType type) {
    if (date != null) {
      return GestureDetector(
        onTap: () {
          if (type == DateType.theory) {
            logic.controller.bookingModel.theoryDate!.remove(date);
          }
          if (type == DateType.dive) {
            logic.controller.bookingModel.diveDate!.remove(date);
          }
          if (type == DateType.pool) {
            logic.controller.bookingModel.poolDate!.remove(date);
          }
          logic.controller.update();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.background.lightSkyBlue,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM  dd @ hh:mm a').format(date)),
                Spacing.w20,
                const Icon(
                  Icons.close,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget buildContinueButton(BuildContext context) {
    return Center(
      child: AppButton.flat(
        text: 'Continue',
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: () {
          logic.onContinueChooseDatesPressed(context);
        },
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
}

enum DateType {
  theory,
  pool,
  dive,
}

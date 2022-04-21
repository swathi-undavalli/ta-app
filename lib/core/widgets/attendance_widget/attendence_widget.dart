import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/attendance_widget/attandence_widget_controller.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AttendanceWidget extends StatelessWidget {
  final bool showDismiss = false;
  final AttendanceWidgetLogic logic = AttendanceWidgetLogic();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCheckIn(),
        buildCheckOut(),
      ],
    );
  }

  Widget buildCheckIn() {
    return GetBuilder<AttendanceWidgetController>(builder: (controller) {
      if (controller.showCheckIn)
        return Container(
          width: 321,
          height: 137,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Just Arrived ? Please ',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.nunito,
                            color: AppColors.text.black,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Check-in.',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.nunito,
                            color: AppColors.text.skyBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Are you at office please Check-in.",
                  style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: 13,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showDismiss)
                      AppButton.miniText(
                        text: 'DISMISS',
                        onTap: () {
                          controller.showCheckIn = false;
                        },
                      ),
                    SizedBox(width: 30),
                    AppButton.miniFlat(
                      text: 'CHECK-IN',
                      onTap: () {
                        logic.onCheckInPressed();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      else
        return Container();
    });
  }

  Widget buildCheckOut() {
    return GetBuilder<AttendanceWidgetController>(builder: (controller) {
      if (controller.showCheckOut)
        return Container(
          width: 321,
          height: 137,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Are You Leaving  ? Please ',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.nunito,
                            color: AppColors.text.black,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Check-out.',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.nunito,
                            color: AppColors.text.skyBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Are you at office please Check-out.",
                  style: TextStyle(
                    fontFamily: AppFonts.nunito,
                    color: AppColors.text.black,
                    fontSize: 13,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showDismiss)
                      AppButton.miniText(
                        text: 'DISMISS',
                        onTap: () {
                          controller.showCheckOut = false;
                        },
                      ),
                    SizedBox(width: 30),
                    AppButton.miniFlat(
                      text: 'CHECK-OUT',
                      onTap: () {
                        logic.onCheckOutPressed();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      else
        return Container();
    });
  }
}

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/attendance/attendance-page-controller.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AttendancePage extends StatelessWidget {
  static const String id = "AttendancePage";
  final AttendancePageLogic logic = AttendancePageLogic(Get.arguments);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendancePageController>(builder: (logic) {
      return Stack(
        children: [
          buildShowLoading(),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "Attendance & Clock",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              leading: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: AppColors.text.black,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(height: 20),
                      // buildBackNavigation(),
                      // SizedBox(height: 20),

                      SizedBox(height: 20),
                      Row(
                        children: [
                          buildEmployeeProfile(),
                          buildEmployeeClock(),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Divider(),
                      // Container(
                      //   width: Get.width,
                      //   height: 30,
                      //   alignment: Alignment.centerLeft,
                      //   child: RichText(
                      //     text: TextSpan(
                      //       text: 'Last login',
                      //       style: TextStyle(
                      //         fontFamily: AppFonts.nunito,
                      //         fontWeight: FontWeight.bold,
                      //         color: AppColors.text.black,
                      //       ),
                      //       children: <TextSpan>[
                      //         TextSpan(
                      //           text: '     25-01-2001 @ 03:00',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: AppColors.text.skyBlue,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: Get.width,
                      //   alignment: Alignment.centerLeft,
                      //   height: 30,
                      //   child: RichText(
                      //     text: TextSpan(
                      //       text: 'Login location',
                      //       style: TextStyle(
                      //         fontFamily: AppFonts.nunito,
                      //         fontWeight: FontWeight.bold,
                      //         color: AppColors.text.black,
                      //       ),
                      //       children: <TextSpan>[
                      //         TextSpan(
                      //           text: '     Pondicherry',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: AppColors.text.skyBlue,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Divider(),

                      // SizedBox(height: 10),

                      Divider(),
                      SizedBox(height: 10),

                      // SizedBox(height: 10),
                      // Container(
                      //   width: Get.width,
                      //   child: Text("Attendance Calender",
                      //       style: TextStyle(fontWeight: FontWeight.bold)),
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Attendance Calender",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // SizedBox(),
                            buildSelectMonthButton(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      buildCalender(),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       var today = DateTime.now();
                      //       for (int i = 0; i < 100; i++) {
                      //         today = today.add(Duration(days: 1));
                      //         Attendance attendance = Attendance(
                      //           checkInInput: "TA-Mobile App",
                      //           checkInLocation: "Temple Adventures Pondicherry",
                      //           checkInTime: Timestamp.fromMillisecondsSinceEpoch(
                      //               today.millisecondsSinceEpoch),
                      //           checkOutInput: "TA-Mobile App",
                      //           checkOutLocation: "Temple Adventures Pondicherry",
                      //           checkOutTime:
                      //               Timestamp.fromMillisecondsSinceEpoch(
                      //                   today.millisecondsSinceEpoch),
                      //           date: Timestamp.fromMillisecondsSinceEpoch(
                      //               today.millisecondsSinceEpoch),
                      //           punctual: "On-Time",
                      //         );
                      //         FirebaseFirestore.instance
                      //             .collection("employees")
                      //             .doc("-2")
                      //             .collection("attendance")
                      //             .doc(DateFormat("dd-MM-yyyy").format(today))
                      //             .set(attendance.toMap());
                      //       }
                      //     },
                      //     child: Text("DO")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildEmployeeClock() {
    return Expanded(
      child: Center(
        child: GetBuilder<AttendancePageController>(builder: (controller) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircularStepProgressIndicator(
                      totalSteps: (5 * 60 * 60) ~/ 1000,
                      currentStep: (controller.clockData != null)
                          ? (logic
                              .getPositiveNumber(controller.clockData ~/ 1000))
                          : 0,
                      stepSize: 5,
                      selectedColor: (controller.clockData != null &&
                              controller.clockData > 0)
                          ? AppColors.background.skyBlue
                          : AppColors.background.red,
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: 75,
                      height: 75,
                      selectedStepSize: 5,
                      roundedCap: (_, __) => true,
                      circularDirection: (controller.clockData != null &&
                              controller.clockData > 0)
                          ? CircularDirection.clockwise
                          : CircularDirection.counterclockwise,
                    ),
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: Center(
                        child: Text(
                          (controller.clockData != null)
                              ? "${((controller.clockData < 0) ? "- " : "") + logic.getTimeFromSeconds(controller.clockData)}"
                              : "--",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.small,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Clock",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Expanded buildEmployeeProfile() {
    return Expanded(
      child: Column(
        children: [
          buildUserProfile(),
          SizedBox(height: 20),
          GetBuilder<AttendancePageController>(builder: (controller) {
            return Text(controller.currentEmployee.name);
          }),
        ],
      ),
    );
  }

  ///====================UI================///\

  Widget buildShowLoading() {
    return GetBuilder<AttendancePageController>(builder: (controller) {
      if (controller.showLoading)
        return Container(
          color: Colors.black54,
          height: Get.height,
          width: Get.width,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
        );
      else
        return Container();
    });
  }

  SizedBox buildUserProfile() {
    return SizedBox(
      height: 75,
      width: 75,
      child: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"),
      ),
    );
  }

  getBoxColor(DateTime date) {
    for (int i = 0; i < logic.controller.absentDates.length; i++) {
      if ((date.day == logic.controller.absentDates[i].day) &&
          (date.month == logic.controller.absentDates[i].month) &&
          (date.year == logic.controller.absentDates[i].year)) {
        return Colors.red.shade50;
      }
    }
    return Colors.white;
  }

  Widget buildCalender() {
    var now = DateTime.now();
    return GetBuilder<AttendancePageController>(builder: (controller) {
      print(controller.selectedDate);
      return Center(
        child: Column(
          children: [
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: controller.days
                  .map(
                    (e) => Container(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Text(
                          e,
                          style: TextStyle(
                              color: (e == "Sat" || e == "Sun")
                                  ? Colors.red
                                  : Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Wrap(spacing: 15, runSpacing: 15, children: [
                ...List<Widget>.generate(
                    logic.getOrderOfDates(),
                    (_) => Container(
                          height: 30,
                          width: 30,
                        )),
                ...controller.calenderDates.map(
                  (e) {
                    return Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: getBoxColor(e),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              e.day.toString(),
                              style: TextStyle(
                                  color: (e.day == now.day &&
                                          e.month == now.month &&
                                          e.year == now.year)
                                      ? AppColors.text.skyBlue
                                      : Colors.grey,
                                  fontSize: FontSize.small,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ]),
            ),
          ],
        ),
      );
    });
  }

  Widget buildSelectedMonthYearText() {
    return GetBuilder<AttendancePageController>(builder: (controller) {
      return Text(
        // controller.selectedDate.month.toString()
        DateFormat('MMM  yyyy').format(controller.selectedDate),
        style: TextStyle(
            color: AppColors.text.black,
            fontSize: FontSize.textSize,
            fontWeight: FontWeight.bold),
      );
    });
  }

  Widget buildSelectMonthButton(BuildContext context) {
    return GetBuilder<AttendancePageController>(builder: (controller) {
      return AppButton.miniFlat(
        text: DateFormat('MMM  yyyy').format(controller.selectedDate),
        onTap: () {
          logic.datePicker(context);
        },
        enable: true,
      );
    });
  }

  Widget buildBackNavigation() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: AppColors.text.black,
            ),
          ),
          Text(
            "Attendance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

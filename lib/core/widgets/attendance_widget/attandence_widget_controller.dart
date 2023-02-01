import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/services/data_persistance.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/attendance_widget/attendence_repo.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AttendanceWidgetLogic {
  AttendanceWidgetController controller = Get.put(AttendanceWidgetController());

  AttendanceWidgetLogic() {
    getAttendanceData();
  }

  Future<void> reloadData() async {
    await getAttendanceData();
    controller.update();
  }

  getAttendanceData() async {
    //print("getAttendanceData");
    controller.showCheckIn = false;
    controller.showCheckOut = false;
    await AttendanceRepo.synchronize();
    //print(AttendanceRepo.attendance.toMap());
    if (AttendanceRepo.attendance.checkInLocation == null)
      controller.showCheckIn = true;
    else if (AttendanceRepo.attendance.checkOutLocation == null)
      controller.showCheckOut = true;
  }

  getLocation() async {
    //print("getLocation....");
    controller.currentLocation = "Fetching.....";
    controller.currentLocation = await AttendanceRepo.getUserPosition();
    //print(DateTime.now());
  }

  startTimer() async {
    var count = 0;
    while (count < 60) {
      await Future.delayed(Duration(seconds: 1));
      count++;
      controller.date = DateTime.now();
    }
    if (Get.isDialogOpen!) Get.back();
  }

  onCheckInPressed() async {
    onCheckInConfirmPressed() {
      var shift = DateTime(0, 0, 0, currentEmployee!.shiftTiming!.hour,
          currentEmployee!.shiftTiming!.minute);
      var now = DateTime.now();
      var present = DateTime(
        0,
        0,
        0,
        now.hour,
        now.minute,
      );

      //print(present.difference(shift).inMinutes);

      if (present.difference(shift).inMinutes > 10) {
        Get.defaultDialog(
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          title: "",
          content: Column(
            children: [
              Text(
                "You're late by ${(present.difference(shift).inHours != 0) ? (present.difference(shift).inHours.toString() + " hour ") : ""}${present.difference(shift).inMinutes % 60} minutes",
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 30,
              ),
              AppButton.miniFlat(
                text: "Okay",
                onTap: () {
                  AttendanceRepo.checkIn();
                  controller.showCheckIn = false;
                  controller.showCheckOut = true;
                  Get.back();
                  Get.back();
                },
              )
            ],
          ),
        );
      } else {
        AttendanceRepo.checkIn();
        controller.showCheckIn = false;
        controller.showCheckOut = true;
        Get.back();
      }
    }

    getLocation();
    startTimer();
    Get.defaultDialog(
      contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: "",
      content: GetBuilder<AttendanceWidgetController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.text.skyBlue,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    controller.currentLocation,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("You are Checking in to the Office."),
            SizedBox(height: 20),
            Text(
              "${controller.date.hour}:${controller.date.minute}:${controller.date.second}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniText(
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
                AppButton.miniFlat(
                  text: "Confirm",
                  // enable: (controller.currentLocation != "Fetching....." &&
                  //     controller.currentLocation != "Invalid Location"),
                  onTap: onCheckInConfirmPressed,
                ),
              ],
            ),
          ],
        );
      }),
      cancelTextColor: Colors.red,
      confirmTextColor: AppColors.text.skyBlue,
      backgroundColor: Colors.white,
      titleStyle: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      barrierDismissible: true,
      radius: 10,
    );
  }

  onCheckOutPressed() async {
    onCheckOutConfirmPressed() {
      AttendanceRepo.checkOut();
      controller.showCheckOut = false;
      Get.back();
    }

    getLocation();
    startTimer();
    Get.defaultDialog(
      contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: "",
      content: GetBuilder<AttendanceWidgetController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.text.skyBlue,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    controller.currentLocation,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("You are Checking out from the Office."),
            SizedBox(height: 20),
            Text(
              "${controller.date.hour}:${controller.date.minute}:${controller.date.second}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniText(
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
                AppButton.miniFlat(
                  text: "Confirm",
                  enable: (controller.currentLocation != "Fetching....." &&
                      controller.currentLocation != "Invalid Location"),
                  onTap: onCheckOutConfirmPressed,
                ),
              ],
            ),
          ],
        );
      }),
      cancelTextColor: Colors.red,
      confirmTextColor: AppColors.text.skyBlue,
      backgroundColor: Colors.white,
      titleStyle: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      barrierDismissible: true,
      radius: 10,
    );
  }
}

class AttendanceWidgetController extends GetxController {
  bool _showCheckIn = false;
  String _showLocation = "Fetching Location......";
  DateTime _date = DateTime.now();
  bool _showCheckOut = false;

  DateTime get date => _date;

  bool get showCheckIn => _showCheckIn;
  bool get showCheckOut => _showCheckOut;

  String get currentLocation => _showLocation;

  set currentLocation(String value) {
    _showLocation = value;
    update();
  }

  set date(DateTime value) {
    _date = value;
    update();
  }

  set showCheckIn(bool value) {
    _showCheckIn = value;
    update();
  }

  set showCheckOut(bool value) {
    _showCheckOut = value;
    update();
  }
}

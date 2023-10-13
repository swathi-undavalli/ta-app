import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back_navigation_icon.dart';
import 'package:temple_adventures/features/bookings/models/booking_model.dart';
import 'firebase_messaging_controller.dart';

class NotificationsScreen extends StatelessWidget {
  static const String id = "NotificationsScreen";

  final NotificationsLogic logic = NotificationsLogic();

  final RemoteMessage? message = Get.arguments;

  NotificationsScreen() {
    checkFireBase();
  }

  void checkFireBase() async {
    logic.controller.loading = true;
    log(message!.data["booking_id"]);
    var data = await FirebaseFirestore.instance.collection("bookings").doc(message!.data["booking_id"]).get();
    logic.controller.bookingModel = Booking.fromMap(data.data()!);
    logic.controller.update();
    logic.controller.loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
      return Stack(
        children: [
          buildShowLoading(),
          Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              centerTitle: true,
              // title: buildTitle(),
              leading: BackNavigationIcon(),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: GetBuilder<NotificationController>(builder: (controller) {
                return SingleChildScrollView(
                  child: Container(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Hurrah !!",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: AppColors.text.skyBlue),
                        ),
                        SizedBox(height: 30),
                        buildHeading(
                            title: "New Booking Created by", text: controller.bookingModel?.employeeName ?? ""),
                        SizedBox(height: 50),
                        buildBookingDetails(title: "Booking ID", text: controller.bookingModel?.id ?? ""),
                        buildBookingDetails(
                            title: "Name",
                            text: "${controller.bookingModel?.pax?[0]["first-name"] ?? ""} "
                                "${controller.bookingModel?.pax?[0]["last-name"] ?? ""}"),
                        buildBookingDetails(title: "Pax", text: controller.bookingModel?.noOfPersons.toString()),
                        buildBookingDetails(title: "Email ID", text: controller.bookingModel?.pax![0]["email"]),
                        buildBookingDetails(
                            title: "Total Amount",
                            text: (controller.bookingModel?.totalCost.toStringAsFixed(0) ?? "-") + "/-"),
                        buildBookingDetails(
                            title: "Deposit", text: (controller.bookingModel?.paid?.toStringAsFixed(0) ?? "-") + "/-"),
                        buildBookingDetails(
                            title: "Balance",
                            text: ((controller.bookingModel?.totalCost ?? 0) - (controller.bookingModel?.paid ?? 0))
                                    .toStringAsFixed(0) +
                                "/-"),
                        buildBookingDetails(title: "Receipt No", text: controller.bookingModel?.receiptNo),
                        buildBookingDetails(title: "Payment Mode", text: controller.bookingModel?.paymentMode),
                        buildBookingDetails(
                            title: "Transaction ID", text: controller.bookingModel?.paymentTransactionId),
                        buildBookingDetails(title: "Activity", text: controller.bookingModel?.activity?[0]?.name),
                        buildDates(title: "Dive Dates", dates: controller.bookingModel?.diveDate),
                        buildDates(title: "Theory Dates", dates: controller.bookingModel?.theoryDate),
                        buildDates(title: "Pool Dates", dates: controller.bookingModel?.poolDate),
                        buildBookingDetails(title: "Remarks", text: controller.bookingModel?.remarks),
                      ],
                    ).paddingOnly(top: 0, left: 30, right: 30, bottom: 30),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  Widget buildShowLoading() {
    return GetBuilder<NotificationController>(builder: (controller) {
      if (controller.loading)
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

  Widget buildBookingDetails({required String title, String? text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 12, fontFamily: AppFonts.nunito, color: AppColors.text.black, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: 150,
            child: Text(
              (text != null && text.isNotEmpty) ? "$text" : "-",
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFonts.nunito,
                  color: AppColors.text.black,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeading({String? title, String? text}) {
    return Container(
      width: Get.width,
      child: FittedBox(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.nunito,
                    color: AppColors.text.black,
                    fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: "  $text ",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.nunito,
                    color: AppColors.text.skyBlue,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDates({required String title, required List<DateTime?>? dates}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 12, fontFamily: AppFonts.nunito, color: AppColors.text.black, fontWeight: FontWeight.w500),
            ),
          ),
          (dates != null && dates.isNotEmpty)
              ? Column(
                  children: [
                    ...dates.map(
                      (e) {
                        String date = DateFormat('dd-MM-yyyy @ hh:mm a').format(e!);
                        return Container(
                            width: 150,
                            child: Text(
                              "$date",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppFonts.nunito,
                                  color: AppColors.text.black,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis),
                            ));
                      },
                    )
                  ],
                )
              : Container(width: 150, child: Text("-")),
        ],
      ),
    );
  }
}
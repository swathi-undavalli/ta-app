import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/logs/presentation/screens/details-screen.dart';
import 'dart:developer' as dev;

import '../../../../notification-screen.dart';

class LogScreen extends StatelessWidget {
  static const String id = "LogScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('logs')
                  .orderBy('timeStamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data != null) {
                      Map<String, dynamic>? map = snapshot.data?.docs[index]
                          .data() as Map<String, dynamic>?;
                      if (map != null) {
                        LogModel logModel = LogModel.fromMap(map);
                        return buildLog(
                          log: logModel,
                        );
                      }
                    }
                    return SizedBox();
                  },
                );
              }),
        ),
      ),
    );
  }

  Widget buildLog({required LogModel log}) {
    dev.log("building .......");
    getIcon() {
      switch (log.type) {
        case LogType.bookingCreated:
        case LogType.bookingDeleted:
        case LogType.bookingEdited:
        case LogType.quickBookingCreated:
          return Text(
            log.bookingId!,
            style: TextStyle(
              color: AppColors.text.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.nunito,
            ),
          );
        case LogType.signedIn:
          return Icon(
            Icons.login_outlined,
            color: AppColors.text.white,
            size: 23,
          );
        case LogType.signedOut:
          return Icon(
            Icons.logout_outlined,
            color: AppColors.text.white,
            size: 23,
          );
        case LogType.addActivity:
          return Image.asset(
            "images/outline_scuba_diving_black_24dp.png",
            color: AppColors.background.white,
            height: 23,
            width: 23,
          );
        case LogType.editActivity:
          return Image.asset(
            "images/outline_scuba_diving_black_24dp.png",
            color: AppColors.background.white,
            height: 23,
            width: 23,
          );
        case LogType.addEmployee:
          return Icon(
            Icons.account_circle_rounded,
            color: AppColors.text.white,
            size: 23,
          );
        case LogType.editEmployee:
          return Icon(
            Icons.account_circle_rounded,
            color: AppColors.text.white,
            size: 23,
          );
        case LogType.deleteEmployee:
          return Icon(
            Icons.account_circle_rounded,
            color: AppColors.text.white,
            size: 23,
          );
        case LogType.bookingPaxDeleted:
          return Icon(
            Icons.person_remove_rounded,
            color: AppColors.text.white,
            size: 23,
          );
      }
    }

    getColor() {
      switch (log.type) {
        case LogType.bookingCreated:
        case LogType.bookingEdited:
        case LogType.bookingDeleted:
          return AppColors.text.skyBlue;
        case LogType.signedIn:
          return AppColors.text.skyBlue;
        case LogType.signedOut:
          return AppColors.text.skyBlue;
        case LogType.addActivity:
          return AppColors.text.skyBlue;
        case LogType.editActivity:
          return AppColors.text.skyBlue;
        case LogType.addEmployee:
          return AppColors.text.skyBlue;
        case LogType.editEmployee:
          return AppColors.text.skyBlue;
        case LogType.deleteEmployee:
          return AppColors.text.skyBlue;
        case LogType.bookingPaxDeleted:
          return AppColors.text.orange;

        default:
          return AppColors.text.skyBlue;
      }
    }

    getTitle() {
      switch (log.type) {
        case LogType.bookingCreated:
          return "Booking Created";
        case LogType.bookingEdited:
          return "Booking Edited";
        case LogType.bookingDeleted:
          return "Booking Deleted";
        case LogType.signedIn:
          return "Signed In";
        case LogType.signedOut:
          return "Signed Out";
        case LogType.addActivity:
          return "Added ${log.activityName} ";
        case LogType.editActivity:
          return "Edited ${log.activityName} ";
        case LogType.addEmployee:
          return "Added ${log.employeeName}";
        case LogType.editEmployee:
          return "Edited ${log.employeeName}";
        case LogType.deleteEmployee:
          return "Deleted ${log.employeeName}";
        case LogType.bookingPaxDeleted:
          return "PAX Deleted";
        case LogType.quickBookingCreated:
          return "Quick Booking Created";
      }
    }

    return GestureDetector(
      onTap: () async {
        if (getTitle() == "Booking Created") {
          var data = await FirebaseFirestore.instance
              .collection("bookings")
              .doc(log.bookingId!.trim())
              .get();
          if (data.data() != null) {
            print(log.bookingId);
            Get.toNamed(DetailsScreen.id, arguments: data.data());
          } else {
            Fluttertoast.showToast(
                msg: "${log.bookingId} Booking Doesn't Exit");
          }
        } else {
          return;
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: getColor()),
                child: Center(
                  child: getIcon(),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      getTitle(),
                      style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.nunito,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${log.createdBy}",
                    style: TextStyle(
                      color: AppColors.text.darkgrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.nunito,
                    ),
                  ),
                ],
              ),
              // Spacer(),
              Expanded(
                  child: Container(
                color: Colors.transparent,
              )),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("dd MMM, yyyy").format(log.timeStamp!.toDate()),
                    style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.nunito,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat("hh:mm a").format(log.timeStamp!.toDate()),
                    style: TextStyle(
                      color: AppColors.text.skyBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.nunito,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 1.0, right: 1.0, top: 17, bottom: 17),
            child: Container(
              height: 1,
              width: Get.width,
              color: AppColors.text.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      'Logs',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }
}

enum LogType {
  signedIn,
  signedOut,
  bookingCreated,
  quickBookingCreated,
  bookingDeleted,
  bookingPaxDeleted,
  bookingEdited,
  addActivity,
  editActivity,
  editEmployee,
  addEmployee,
  deleteEmployee,
}

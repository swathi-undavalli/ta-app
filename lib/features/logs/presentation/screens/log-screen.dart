import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: checkFireBase(),
            // child: Column(
            //   children: [
            //     buildLog(
            //         bookingId: "115",
            //         title: "Booking Created",
            //         name: "Sahitha Chowdary",
            //         logType: LogType.bookingCreated),
            //     buildLog(
            //         title: "Signed In",
            //         name: "Vendhan",
            //         logType: LogType.signedIn),
            //     buildLog(
            //         bookingId: "116",
            //         title: "Booking Created",
            //         name: "Donaran Das",
            //         logType: LogType.bookingCreated),
            //     buildLog(
            //         bookingId: "116",
            //         title: "Booking Edited",
            //         name: "Donaran Das",
            //         logType: LogType.bookingEdited),
            //     buildLog(
            //         title: "Signed Out",
            //         name: "Rosy",
            //         logType: LogType.signedOut),
            //     buildLog(
            //         bookingId: "117",
            //         title: "Booking Deleted",
            //         name: "Kamesh",
            //         logType: LogType.bookingEdited),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

  Widget checkFireBase() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('logs').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: snapshot.data.docs.map((document) {
              print("Started");
              return buildLog(
                logType: convertToEnum(document["type"]),
              );
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 6,
                  child: Text(
                    "Type: " + document["type"],
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  convertToEnum(String e) {
    switch (e) {
      case "bookingCreated":
        return LogType.bookingCreated;
      case "bookingEdited":
        return LogType.bookingEdited;
      case "bookingDeleted":
        return LogType.bookingDeleted;
      case "signedIn":
        return LogType.signedIn;
      case "signedOut":
        return LogType.signedOut;
    }
  }

  Widget buildLog(
      {LogType logType = LogType.bookingCreated,
      String title = "Booking Created",
      String name = "Sahitha",
      String bookingId = "119"}) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: getColor(logType)),
              child: Center(
                child: getIcon(logType, bookingId),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.nunito,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.nunito,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "25 Sep, 2020",
                  style: TextStyle(
                    color: Color(0xff66B700),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.nunito,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "12:00 AM",
                  style: TextStyle(
                    color: Color(0xff1CC900),
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
          padding:
              const EdgeInsets.only(left: 1.0, right: 1.0, top: 17, bottom: 17),
          child: Container(
            height: 1,
            width: Get.width,
            color: AppColors.text.grey,
          ),
        ),
      ],
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

  getIcon(LogType type, String bookingId) {
    switch (type) {
      case LogType.bookingCreated:
      case LogType.bookingDeleted:
      case LogType.bookingEdited:
        return Text(
          bookingId,
          style: TextStyle(
            color: AppColors.text.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.nunito,
          ),
        );
      case LogType.signedIn:
        return Icon(
          Icons.check,
          color: AppColors.text.white,
        );

      case LogType.signedOut:
        return Icon(
          Icons.clear,
          color: AppColors.text.white,
        );
    }
  }

  getColor(LogType type) {
    switch (type) {
      case LogType.bookingCreated:
      case LogType.bookingEdited:
      case LogType.bookingDeleted:
        return AppColors.text.skyBlue;
      case LogType.signedIn:
        return Colors.greenAccent;
      case LogType.signedOut:
        return Colors.redAccent;
    }
  }
}

enum LogType {
  signedIn,
  signedOut,
  bookingCreated,
  bookingDeleted,
  bookingEdited,
  addActivity,
  editActivity,
  editEmployee,
  addEmployee,
  deleteEmployee,

}

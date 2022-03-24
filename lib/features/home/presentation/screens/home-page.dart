import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/D/d.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/add_employee_widget/add_employee_widget.dart';
import '../../../../core/widgets/attendance_report_widget/attendance_report_widget.dart';
import '../../../../core/widgets/attendance_widget/attandence_widget_controller.dart';
import '../../../../core/widgets/attendance_widget/attendence_widget.dart';
import '../../../bookings/models/booking-model.dart';
import '../../controller/home-page-controller.dart';

class HomePage extends StatelessWidget {
  final HomePageLogic logic = HomePageLogic();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        var futures = <Future>[];

        AttendanceWidgetLogic attendanceWidgetLogic = AttendanceWidgetLogic();
        AttendanceReportWidgetLogic attendanceReportWidgetLogic =
            AttendanceReportWidgetLogic();

        futures.add(attendanceWidgetLogic.reloadData());
        futures.add(attendanceReportWidgetLogic.reloadData());

        await Future.wait(futures).whenComplete(() => log("all done"));
      },
      child: Scaffold(
        backgroundColor: AppColors.background.lightBlue,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 10),
                    width: Get.width,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        dashboardDrawerKey.currentState.openDrawer();
                      },
                      icon: Icon(Icons.menu_rounded),
                    ),
                  ),
                  SizedBox(height: 10),
                  AttendanceWidget(),
                  SizedBox(height: 20),
                  AddEmployeeWidget(),
                  SizedBox(height: 20),
                  AttendanceReportWidget(),
                  SizedBox(height: 100),

                  // ElevatedButton(
                  //     onPressed: () {
                  //
                  //
                  //
                  //     },
                  //     child: Text("DO")),

                  // ElevatedButton(
                  //   onPressed: () async {
                  //     for (int i = 109; i < 520; i++) {
                  //       log(i.toString());
                  //       // if (i == 111) break;
                  //       var data = await FirebaseFirestore.instance
                  //           .collection("bookings")
                  //           .doc(i.toString())
                  //           .get();
                  //
                  //       if (data.data() == null) continue;
                  //       BookingModel booking =
                  //           BookingModel.fromMap(data.data());
                  //       booking.payments = [booking.paid];
                  //
                  //       FirebaseFirestore.instance
                  //           .collection("bookings")
                  //           .doc(booking.id)
                  //           .set(booking.toMap())
                  //           .whenComplete(() => log("done"));
                  //     }
                  //   },
                  //   child: Text("Do"),
                  // ),

                  // ElevatedButton(
                  //   onPressed: () async {
                  //     log("clicked");
                  //     for (int i = 47; i < 54; i++) {
                  //       var accessLevels = AccessLevels(
                  //         viewBookings: true,
                  //         createBookings: true,
                  //         editBookings: true,
                  //         viewEmployees: true,
                  //         createEmployees: true,
                  //         editEmployees: true,
                  //         personalProfileEdit: true,
                  //         personalAttendanceReport: true,
                  //         attendanceReport: true,
                  //         weatherReport: true,
                  //         editActivityPrices: true,
                  //         addActivity: true,
                  //         notifications: false,
                  //       );
                  //
                  //       var data = await FirebaseFirestore.instance
                  //           .collection("employees")
                  //           .doc(i.toString())
                  //           .collection("employeeFullInformation")
                  //           .doc("employeeData")
                  //           .get();
                  //
                  //       var employee = Employee.fromMap(data.data());
                  //       employee.accessLevels = accessLevels;
                  //
                  //       FirebaseFirestore.instance
                  //           .collection("employees")
                  //           .doc(i.toString())
                  //           .collection("employeeFullInformation")
                  //           .doc("employeeData")
                  //           .set(employee.toMap());
                  //     }
                  //   },
                  //   child: Text("Do"),
                  // ),
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       log("Finiding count");
                  //       var rawData = await FirebaseFirestore.instance
                  //           .collection("counter")
                  //           .doc("employee")
                  //           .get();
                  //       var data = rawData.data();
                  //       log(rawData.data().toString());
                  //     },
                  //     child: Text("DO"))

                  // ElevatedButton(
                  //   onPressed: () async {
                  //     var token = await FirebaseMessaging.instance.getToken();
                  //     print(token);
                  //   },
                  //   child: Text("DO"),
                  // ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     Get.toNamed(Search.id);
                  //   },
                  //   child: Text("Do"),
                  // ),

                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

getString(List<String> sublist) {
  if (sublist.length != 0) {
    return sublist[0];
  }
  return "";
}

// Future<String> getPDFlink({
//   @required String email,
//   @required List<String> activity,
//   @required String location,
//   @required String fName,
//   @required String lName,
//   @required String bday,
//   @required String ad1,
//   @required String ad2,
//   @required String con,
//   @required String state,
//   @required String city,
//   @required String pin,
//   @required String phone,
//   @required String gen,
// }) async {
//   String api = "https://templeadventures.com/api/v1/generatePdf/";
//   var body = {
//     "email": email,
//     "Activity": activity,
//     "Location": location,
//     "first-name": fName,
//     "last-name": lName,
//     "Birthday": bday,
//     "Address-1": ad1,
//     "Address-2": ad2,
//     "Country": con,
//     "State": state,
//     "City": city,
//     "Pin-Code": pin,
//     "Phone": phone,
//     "Gender": gen,
//   };
//
//   var dio = Dio();
//   try {
//     print("started");
//     FormData formData = new FormData.fromMap(body);
//     var response = await dio.post(api, data: formData);
//     var data = jsonDecode(response.data);
//     print(response.data);
//     print(data[0]);
//     return data[0];
//     print("ended");
//   } catch (e) {
//     print(e);
//   }
//   return "no data found";
// }
//
// Future<File> showPDFh() async {
//   print("getting url");
//   String link = await getPDFlink(
//     email: "kamesh.wb@gmail.com",
//     activity: ["Open Water"],
//     location: "Puducherry",
//     fName: "Siddharth",
//     lName: "Jha",
//     bday: "1993-07-26",
//     ad1: "TEST",
//     ad2: "TEST",
//     con: "India",
//     state: "Maharashtra",
//     city: "Mumbai",
//     pin: "411015",
//     phone: "8329889224",
//     gen: "Male",
//   );
//   var response = await http.get(Uri.parse(link));
//
//   var documentDirectory = await getTemporaryDirectory();
//
//   var file = File(join(
//       documentDirectory.path, '${DateTime.now().micr
//   osecondsSinceEpoch}.pdf'));
//
//   print(1);
//   file.writeAsBytesSync(response.bodyBytes);
//   print(2);
//   await Pspdfkit.present(file.path);
//   return file;
// }

// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromMap(jsonString);

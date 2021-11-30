import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/services/firebase_api.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/add_employee_widget/add_employee_widget.dart';
import 'package:temple_adventures/core/widgets/attendance_report_widget/attendance_report_widget.dart';
import 'package:temple_adventures/core/widgets/attendance_widget/attandence_widget_controller.dart';
import 'package:temple_adventures/core/widgets/attendance_widget/attendence_widget.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/home/controller/home-page-controller.dart';
import 'package:temple_adventures/features/home/presentation/widgets/nav-drawer.dart';
// import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:pspdfkit_flutter/src/main.dart';

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
                    margin: EdgeInsets.only(left: 10, top: 10),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// for (var employee in employees) {
//   var id = employee[0];
//   var name = employee[1];
//   var phone = employee[2];
//   var names = name.split(" ");
//   Employee emp = Employee(
//       id: id,
//       firstName: names[0],
//       lastName: getString(names.sublist(1)),
//       phoneNumber: "+91" + phone,
//       role: "Office Staff",
//       shiftTiming: DateTime(0, 0, 0, 9),
//       accessLevels: AccessLevels(
//         attendence: true,
//         booking: false,
//       ));
//   FirebaseFirestore.instance
//       .collection("employees")
//       .doc(id)
//       .collection("employeeFullInformation")
//       .doc("employeeData")
//       .set(emp.toMap());
//   print(emp.toMap().toString());
// }

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
//       documentDirectory.path, '${DateTime.now().microsecondsSinceEpoch}.pdf'));
//
//   print(1);
//   file.writeAsBytesSync(response.bodyBytes);
//   print(2);
//   await Pspdfkit.present(file.path);
//   return file;
// }

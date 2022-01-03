import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/attendance/attendance-page.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/employees/controllers/add-an-employee-controller.dart';
import 'package:temple_adventures/features/employees/presentation/screens/add-an-employee-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  static const String id = "EmployeeDetailsScreen";
  final employeeArgument = Get.arguments;
  AddAnUserLogic logic = AddAnUserLogic();

  @override
  Widget build(BuildContext context) {
    final DateTime date = employeeArgument.shiftTiming;
    final DateFormat formatter = DateFormat('HH-mm-ss');
    final String shiftTiming = formatter.format(date);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background.lightBlue,
        elevation: 0,
        leading: BackNavigationIcon(),
      ),
      backgroundColor: AppColors.background.lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: buildUserProfile(),
                ),
                SizedBox(height: 20),
                Text(
                  employeeArgument.name,
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontWeight: FontWeight.w700,
                      fontSize: FontSize.textSize),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildIcons(
                      Icons.call_rounded,
                      () {
                        makingPhoneCall(employeeArgument.phoneNumber,
                            employeeArgument.countryCode);
                      },
                    ),
                    EmployeeAccess(
                      access: AccessRights.editEmployees,
                      child: buildIcons(Icons.edit, () async {
                        if (await checkFirebase()) {
                          await Future.delayed(Duration(milliseconds: 300));
                          Get.toNamed(AddAnUser.id, arguments: true);
                        }
                      }),
                    ),
                    EmployeeAccess(
                      access: AccessRights.editEmployees,
                      child: buildIcons(
                        Icons.delete,
                        () {
                          Get.defaultDialog(
                            contentPadding: EdgeInsets.only(
                                left: 30, right: 30, top: 20, bottom: 30),
                            title: "\nAre You Sure ? ",
                            middleText: "Account will Be Deleted Permanently.",
                            backgroundColor: Colors.white,
                            titleStyle: TextStyle(
                                color: AppColors.text.black,
                                fontFamily: AppFonts.nunito,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            middleTextStyle: TextStyle(
                                color: AppColors.text.black,
                                fontFamily: AppFonts.nunito,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            confirm: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppButton.miniText(
                                  text: 'Cancel',
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                                AppButton.miniFlat(
                                  text: 'OK',
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection("employees")
                                        .doc(employeeArgument.id)
                                        .collection("employeeFullInformation")
                                        .doc("employeeData")
                                        .delete();
                                    // counterModel.employee--;
                                    // FirebaseFirestore.instance
                                    //     .collection("counter")
                                    //     .doc("count")
                                    //     .set(counterModel.toMap());
                                    LogModel logModel = LogModel(
                                      type: LogType.deleteEmployee,
                                      employeeName: employeeArgument.name,
                                    );
                                    FirebaseFirestore.instance
                                        .collection("logs")
                                        .doc()
                                        .set(logModel.toMap());
                                    Get.back();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            barrierDismissible: false,
                            radius: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                buildTitle("Employee Details"),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildEmployeeInfo(
                          subHeading: "Name", text: employeeArgument.name),
                      buildEmployeeInfo(
                          subHeading: "Phone Number",
                          text: employeeArgument.countryCode +
                              employeeArgument.phoneNumber),
                      buildEmployeeInfo(
                          subHeading: "ShiftTiming", text: shiftTiming),
                      buildEmployeeInfo(
                          subHeading: "Role", text: employeeArgument.role),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                buildTitle("Login Details"),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    children: [
                      buildEmployeeInfo(
                          subHeading: "Login Time", text: "06:00:00"),
                      buildEmployeeInfo(
                          subHeading: "Login Location", text: "Pondicherry"),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerRight,
                        child: AppButton.miniFlat(
                          onTap: () {
                            Get.toNamed(AttendancePage.id,
                                arguments: employeeArgument);
                          },
                          text: "View all ",
                          bgColor: AppColors.background.lightSkyBlue,
                          textColor: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///================UI================///

  Widget buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.skyBlue,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.nunito),
      ),
    );
  }

  Widget buildEmployeeInfo({String subHeading, String text}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 320,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: Get.width,
                child: Text(
                  subHeading,
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              width: 150,
              child: Text(
                ":      " + text,
                style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  makingPhoneCall(String phoneNumber, String code) async {
    String url = 'tel:${code + phoneNumber}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildIcons(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppColors.background.lightSkyBlue),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: AppColors.background.black,
          ),
        ),
      ),
    );
  }

  Widget buildUserProfile() {
    return SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"),
      ),
    );
  }

  checkFirebase() async {
    var info = await FirebaseFirestore.instance
        .collection("employees")
        .doc(employeeArgument.id)
        .collection("employeeFullInformation")
        .doc("employeeData")
        .get();
    if (info.data() != null) {
      Employee employee = Employee.fromMap(info.data());
      print(info.data());
      final DateTime date = employee.shiftTiming;
      final DateFormat formatter = DateFormat('HH-mm-ss');
      final String shiftTiming = formatter.format(date);
      logic.controller.employeeIdTED.text = employee.id;
      logic.controller.firstNameTED.text = employee.firstName;
      logic.controller.lastNameTED.text = employee.lastName;
      logic.controller.shiftTimeTED.text = shiftTiming;
      logic.controller.phoneNumberTED.text = employee.phoneNumber;
      logic.controller.countryCodeTED.text = employee.countryCode;
      logic.controller.countryISoCOde = employee.countryIsoCode;
      logic.controller.genderTED.text = employee.gender;
      logic.controller.roleTED.text = employee.role;

      logic.controller.viewBookings = employee.accessLevels.viewBookings;
      logic.controller.createBookings = employee.accessLevels.createBookings;
      logic.controller.editBookings = employee.accessLevels.editBookings;
      logic.controller.viewEmployees = employee.accessLevels.viewEmployees;
      logic.controller.createEmployees = employee.accessLevels.createEmployees;
      logic.controller.editEmployees = employee.accessLevels.editEmployees;
      logic.controller.personalProfileEdit =
          employee.accessLevels.personalProfileEdit;
      logic.controller.personalAttendanceReport =
          employee.accessLevels.personalAttendanceReport;
      logic.controller.attendanceReport =
          employee.accessLevels.attendanceReport;
      logic.controller.weatherReport = employee.accessLevels.weatherReport;
      logic.controller.editActivityPrices =
          employee.accessLevels.editActivityPrices;
      logic.controller.addActivity = employee.accessLevels.addActivity;

      return true;
    }
    return false;
  }
}

///TODO :: Check Please
// class EmployeeDetailsScreen extends StatelessWidget {
//   static const String id = "EmployeeDetailsScreen";
//   final employeeArgument = Get.arguments[0];
//   AddAnUserLogic logic = AddAnUserLogic();
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime date = employeeArgument.shiftTiming;
//     final DateFormat formatter = DateFormat('HH-mm-ss');
//     final String shiftTiming = formatter.format(date);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.background.lightBlue,
//         elevation: 0,
//         leading: BackNavigationIcon(),
//       ),
//       backgroundColor: AppColors.background.lightBlue,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 Center(
//                   child: buildUserProfile(),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   employeeArgument.name,
//                   style: TextStyle(
//                       color: AppColors.text.black,
//                       fontWeight: FontWeight.w700,
//                       fontSize: FontSize.textSize),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     buildIcons(
//                       Icons.call_rounded,
//                       () {
//                         makingPhoneCall(employeeArgument.phoneNumber,
//                             employeeArgument.countryCode);
//                       },
//                     ),
//                     buildIcons(Icons.edit, () async {
//                       if (await checkFirebase()) {
//                         await Future.delayed(Duration(milliseconds: 300));
//                         Get.toNamed(AddAnUser.id);
//                       }
//                     }),
//                     buildIcons(
//                       Icons.delete,
//                       () {
//                         Get.defaultDialog(
//                           contentPadding: EdgeInsets.only(
//                               left: 30, right: 30, top: 20, bottom: 30),
//                           title: "\nAre You Sure ? ",
//                           middleText: "Account will Be Deleted Permanently.",
//                           backgroundColor: Colors.white,
//                           titleStyle: TextStyle(
//                               color: AppColors.text.black,
//                               fontFamily: AppFonts.nunito,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                           middleTextStyle: TextStyle(
//                               color: AppColors.text.black,
//                               fontFamily: AppFonts.nunito,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500),
//                           confirm: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               AppButton.miniText(
//                                 text: 'Cancel',
//                                 onTap: () {
//                                   Get.back();
//                                 },
//                               ),
//                               AppButton.miniFlat(
//                                 text: 'OK',
//                                 onTap: () {
//                                   FirebaseFirestore.instance
//                                       .collection("employees")
//                                       .doc(employeeArgument.id)
//                                       .collection("employeeFullInformation")
//                                       .doc("employeeData")
//                                       .delete();
//                                   Get.back();
//                                 },
//                               ),
//                             ],
//                           ),
//                           barrierDismissible: false,
//                           radius: 10,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Divider(),
//                 SizedBox(height: 20),
//                 buildTitle("Employee Details"),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       buildEmployeeInfo(
//                           subHeading: "Name", text: employeeArgument.name),
//                       buildEmployeeInfo(
//                           subHeading: "Phone Number",
//                           text: employeeArgument.countryCode +
//                               employeeArgument.phoneNumber),
//                       buildEmployeeInfo(
//                           subHeading: "ShiftTiming", text: shiftTiming),
//                       buildEmployeeInfo(
//                           subHeading: "Role", text: employeeArgument.role),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 buildTitle("Login Details"),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//                   child: Column(
//                     children: [
//                       buildEmployeeInfo(
//                           subHeading: "Login Time", text: "06:00:00"),
//                       buildEmployeeInfo(
//                           subHeading: "Login Location", text: "Pondicherry"),
//                       SizedBox(height: 10),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         child: AppButton.miniFlat(
//                           onTap: () {
//                             Get.toNamed(AttendancePage.id,
//                                 arguments: employeeArgument);
//                           },
//                           text: "View all ",
//                           bgColor: AppColors.background.lightSkyBlue,
//                           textColor: Colors.black,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///================UI================///
//
//   Widget buildTitle(String text) {
//     return Container(
//       padding: const EdgeInsets.only(left: 20, right: 20),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 16,
//             color: AppColors.text.skyBlue,
//             fontWeight: FontWeight.w700,
//             fontFamily: AppFonts.nunito),
//       ),
//     );
//   }
//
//   Widget buildEmployeeInfo({String subHeading, String text}) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Container(
//         width: 320,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Container(
//                 width: Get.width,
//                 child: Text(
//                   subHeading,
//                   style: TextStyle(
//                       color: AppColors.text.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             Container(
//               width: 150,
//               child: Text(
//                 ":      " + text,
//                 style: TextStyle(
//                     color: AppColors.text.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   makingPhoneCall(String phoneNumber, String code) async {
//     String url = 'tel:${code + phoneNumber}';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Widget buildIcons(IconData icon, Function onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 35,
//         width: 35,
//         decoration: BoxDecoration(
//             shape: BoxShape.circle, color: AppColors.background.lightSkyBlue),
//         child: Center(
//           child: Icon(
//             icon,
//             size: 20,
//             color: AppColors.background.black,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildUserProfile() {
//     return SizedBox(
//       height: 100,
//       width: 100,
//       child: CircleAvatar(
//         backgroundImage: NetworkImage(
//             "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"),
//       ),
//     );
//   }
//
//   checkFirebase() async {
//     var info = await FirebaseFirestore.instance
//         .collection("employees")
//         .doc(employeeArgument.id)
//         .collection("employeeFullInformation")
//         .doc("employeeData")
//         .get();
//     if (info.data() != null) {
//       Employee employee = Employee.fromMap(info.data());
//       print(info.data());
//       final DateTime date = employee.shiftTiming;
//       final DateFormat formatter = DateFormat('HH-mm-ss');
//       final String shiftTiming = formatter.format(date);
//       logic.controller.employeeIdTED.text = employee.id;
//       logic.controller.firstNameTED.text = employee.firstName;
//       logic.controller.lastNameTED.text = employee.lastName;
//       logic.controller.shiftTimeTED.text = shiftTiming;
//       logic.controller.phoneNumberTED.text = employee.phoneNumber;
//       logic.controller.countryCodeTED.text = employee.countryCode;
//       logic.controller.countryISoCOde = employee.countryIsoCode;
//       logic.controller.genderTED.text = employee.gender;
//       // logic.controller.roleTED.text = employee.role;
//       return true;
//     }
//     return false;
//   }
// }

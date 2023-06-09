import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/bottomSheetWidget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/customer-list-widget.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import '../../../../core/authentication/firebase-authentication.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/add_employee_widget/add_employee_widget.dart';
import '../../../../core/widgets/attendance_report_widget/attendance_report_widget.dart';
import '../../../../core/widgets/attendance_widget/attandence_widget_controller.dart';
import '../../../../core/widgets/attendance_widget/attendence_widget.dart';
import '../../../login/presentation/screens/login-page.dart';
import '../../controller/home-page-controller.dart';

class HomePage extends StatelessWidget {
  final HomePageLogic logic = HomePageLogic();
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        var futures = <Future>[];

        AttendanceWidgetLogic attendanceWidgetLogic = AttendanceWidgetLogic();
        AttendanceReportWidgetLogic attendanceReportWidgetLogic = AttendanceReportWidgetLogic();

        futures.add(attendanceWidgetLogic.reloadData());
        futures.add(attendanceReportWidgetLogic.reloadData());

        await Future.wait(futures);
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
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            dashboardDrawerKey.currentState!.openDrawer();
                          },
                          icon: Icon(Icons.menu_rounded),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseAuthentication.logout();
                            Get.offAndToNamed(LoginScreen.id);
                          },
                          icon: Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  AttendanceWidget(),
                  ElevatedButton(
                      onPressed: () {
                        EmpSelectorBottomSheet.show(context);
                      },
                      child: Text("do")),
                  SizedBox(height: 20),
                  AddEmployeeWidget(
                    text: "Add Employees",
                    subText: "Only admins can modify",
                    onTap: () {
                      Get.toNamed(AllEmployeesScreen.id);
                    },
                  ),
                  SizedBox(height: 20),
                  AttendanceReportWidget(),
                  SizedBox(height: 100),
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

  getFirstName(String d) {
    d = d.trim();
    return d.split(" ").first.trim();
  }

  getLastName(String d) {
    d = d.trim();

    return d.replaceAll(getFirstName(d), "").trim();
  }
}

getString(List<String> sublist) {
  if (sublist.length != 0) {
    return sublist[0];
  }
  return "";
}

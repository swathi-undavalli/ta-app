import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/board-plan/presentation/views/board-plan-view.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import '../../../../core/authentication/firebase-authentication.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/add_employee_widget/add_employee_widget.dart';
import '../../../board-plan/presentation/widgets/customer-details.dart';
import '../../../dive-checklist/views/screens/dive-checklist-view.dart';
import '../../../login/presentation/screens/login-page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    selectedDate = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
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
                SizedBox(height: 20),
                // AttendanceWidget(),
                // SizedBox(height: 20),
                AddEmployeeWidget(
                  text: "Add Employees",
                  subText: "Only admins can modify",
                  onTap: () {
                    Get.toNamed(AllEmployeesScreen.id);
                  },
                ),
                Spacing.h10,
                Container(
                  width: 321,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CheckLists",
                            style: TextStyle(
                              fontFamily: AppFonts.nunito,
                              color: AppColors.text.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          buildChecklistTiles(
                              text: "Recreational Student Dive CheckList",
                              onTap: () {
                                Get.toNamed(DiveChecklistView.id, arguments: false);
                              }),
                          Spacing.h5,
                          buildChecklistTiles(
                              text: "Recreational Dive CheckList",
                              onTap: () {
                                Get.toNamed(DiveChecklistView.id, arguments: true);
                              }),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15, vertical: 15),
                ),
                Spacing.h20,
                DSDTable(),
                Spacing.h100,
                Spacing.h50,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChecklistTiles({required String text, required Function onTap}) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.darkgrey,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        AppButton.miniFlat(
          onTap: () {
            onTap();
          },
          text: 'CHECK',
        ),
      ],
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

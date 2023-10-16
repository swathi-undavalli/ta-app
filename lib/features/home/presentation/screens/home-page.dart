import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/core/constants/checklists.dart';
import 'package:temple_adventures/core/util/alignment_extensions.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/employees/model/employee.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import 'package:temple_adventures/features/home/controllers/home-controller.dart';
import 'package:temple_adventures/features/home/presentation/widgets/employee-dive-calender-listTile.dart';
import '../../../../core/authentication/firebase-authentication.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/add_employee_widget/add_employee_widget.dart';
import '../../../dive-checklist/views/screens/dive-checklist-view.dart';
import '../../../login/presentation/screens/login-page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeLogic logic = HomeLogic();

  @override
  void initState() {
    super.initState();
    logic.getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      body: GetBuilder<HomeController>(builder: (controller) {
        return SafeArea(
          child: (!controller.showLoading)
              ? Column(
                  children: [
                    buildMenuAndLogOut().paddingOnly(bottom: 20),
                    if (currentEmployee?.role != "Intern")
                      AddEmployeeWidget(
                        text: "Add Employees",
                        subText: "Only admins can modify",
                        onTap: () {
                          Get.toNamed(AllEmployeesScreen.id);
                        },
                      ).paddingOnly(bottom: 10),
                    buildCheckLists().paddingOnly(bottom: 10),
                    if (currentEmployee?.role == "Intern")
                      Text(
                        "My Dives",
                        style: TextStyle(
                          fontFamily: AppFonts.nunito,
                          color: AppColors.text.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ).paddingOnly(bottom: 20),
                    buildEmployeeDiveCalender(),
                    Spacing.h50,
                  ],
                ).paddingSymmetric(horizontal: 20).scrollable
              : Container(
                  height: Get.height,
                  width: Get.width,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ).center,
                ),
        );
      }),
    );
  }

  Widget buildButton({required Function onTap, required IconData icon}) {
    return SizedBox(
        height: 20,
        width: 20,
        child: IconButton(
            splashRadius: 30,
            padding: EdgeInsets.zero,
            onPressed: () {
              onTap();
            },
            icon: Icon(
              icon,
              color: Colors.black,
              size: 14,
            )));
  }

  Widget buildMenuAndLogOut() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: Get.width,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (currentEmployee?.role != "Intern")
            IconButton(
              onPressed: () {
                dashboardDrawerKey.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu_rounded),
            ),
          Spacer(),
          IconButton(
            onPressed: () {
              FirebaseAuthentication.logout();
              Get.offAndToNamed(LoginScreen.id);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Widget buildEmployeeDiveCalender() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: GetBuilder<HomeController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.h15,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton(
                    onTap: () {
                      logic.onDateChanged(controller.selectedDate.subtract(const Duration(days: 1)));
                    },
                    icon: Icons.arrow_back_ios_rounded),
                Spacing.w20,
                Container(
                  width: 103,
                  child: Text(
                    DateFormat('dd-MMM-yyyy').format(controller.selectedDate),
                    style: TextStyle(
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacing.w20,
                buildButton(
                    onTap: () {
                      logic.onDateChanged(controller.selectedDate.add(const Duration(days: 1)));
                    },
                    icon: Icons.arrow_forward_ios_rounded),
              ],
            ).paddingSymmetric(horizontal: 10),
            Spacing.h5,
            Divider(thickness: 2, color: Colors.black),
            Spacing.h10,
            if (controller.bookings.length == 0 &&
                controller.diveBuddies.length == 0 &&
                controller.generalStaffList.length == 0)
              Text("No tasks assigned").center,
            ...controller.bookings.map(
              (booking) => EmployeeDiveCalenderListTile(
                itemModel: booking,
                selectedDate: controller.selectedDate,
              ),
            ),
            ...controller.diveBuddies.map(
              (e) => buildListTile(
                title: "Dive Buddy",
                value: "${e.name} x ${e.pax} (${e.bookingID})",
              ),
            ),
            ...controller.currentList.map(
              (e) => buildListTile(
                  title: e["role"].toString(), value: "${e["boat_details"]?.name}@ ${e["boat_details"]?.sessionTime}"),
            ),
            ...controller.generalStaffList.map((e) => buildListTile(title: e, value: "Manage / Organize")),
            Spacing.h15,
          ],
        );
      }),
    );
  }

  Widget buildListTile({required String title, String? value}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            value ?? "",
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.darkgrey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 20, vertical: 5);
  }

  Widget buildCheckLists() {
    if (currentEmployee?.role != "Intern")
      return Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
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
            Spacing.h10,
            ...checkLists.map((checklist) => buildChecklistTiles(
                text: checklist.name,
                onTap: () {
                  Get.toNamed(
                    DiveChecklistView.id,
                    arguments: checklist,
                  );
                }).paddingOnly(bottom: 5)),
          ],
        ).paddingSymmetric(horizontal: 15, vertical: 15),
      );
    return SizedBox();
  }

  Widget buildChecklistTiles({required String text, required Function onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.darkgrey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        AppButton.miniText(
          onTap: () {
            onTap();
          },
          text: 'CHECK',
          textColor: AppColors.text.skyBlue,
        ),
      ],
    ).width(Get.width - 80);
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

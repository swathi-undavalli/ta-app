import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/auto-update.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/all-bookings/presentation/screens/all-bookings-screen.dart';
import 'package:temple_adventures/features/boat/presentation/screens/manage-dsd-equipment.dart';
import 'package:temple_adventures/features/employees/presentation/screens/employee-profile-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/attendance/attendance-page.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/all-activities-screen.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import '../../../admin-portal/presentation/admin-portal-screen.dart';

class NavDrawer extends StatelessWidget {
  static const String id = "sideMenuWidget";
  final AutoUpdateLogic logic = AutoUpdateLogic();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            buildUserProfile(),
            SizedBox(height: 20),
            buildName(),
            SizedBox(height: 10),
            buildLine(),
            // buildMenuItem(
            //   icon: Icons.admin_panel_settings_rounded,
            //   text: 'Admin Portal',
            //   onTap: () {
            //     Get.offAndToNamed(AdminPortalScreen.id);
            //   },
            // ),
            buildMenuItem(
              icon: Icons.account_circle,
              text: 'Profile',
              onTap: () {
                Get.offAndToNamed(EmployeeProfileScreen.id);
              },
            ),
            EmployeeAccess(
              access: AccessRights.personalAttendanceReport,
              child: buildMenuItem(
                  icon: Icons.collections_bookmark_rounded,
                  text: 'Attendance',
                  onTap: () {
                    Get.offAndToNamed(AttendancePage.id);
                  }),
            ),
            EmployeeAccess(
              access: AccessRights.editActivityPrices,
              child: buildMenuItem(
                icon: Icons.edit,
                text: 'Edit Prices',
                onTap: () {
                  Get.offAndToNamed(AllActivitiesScreen.id);
                },
              ),
            ),
            EmployeeAccess(
              access: AccessRights.viewBookings,
              child: buildMenuItem(
                icon: Icons.add_to_photos_sharp,
                text: 'All Bookings',
                onTap: () {
                  Get.offAndToNamed(AllBookingsScreen.id);
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.book_rounded,
              text: 'Logs',
              onTap: () {
                Get.offAndToNamed(LogScreen.id);
              },
            ),
            buildMenuItem(
              icon: Icons.directions_boat_sharp,
              text: 'DSD Equipment',
              onTap: () {
                Get.toNamed(ManageDSDEquipment.id);
              },
            ),
            buildLine(),
            (logic.controller.version != null && logic.controller.buildNumber != null)
                ? buildMiniMenuItem(
                    text: "Version : ${logic.controller.version! + "+" + logic.controller.buildNumber!}")
                : buildMiniMenuItem(text: "Loading version number..."),
            buildMiniMenuItem(text: 'templeadventures.com'),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  ///================Business logic==================///

  Widget buildUserProfile() {
    return SizedBox(
      height: 80,
      width: 80,
      child: CircleAvatar(
        backgroundImage: AssetImage('images/AppLogoPondy.png'),
      ),
    );
  }

  Widget buildMiniMenuItem({required text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 15),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(color: Colors.black45, fontSize: FontSize.small),
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required IconData icon, required String text, Color color = Colors.black87, required Function onTap}) {
    return Container(
      width: Get.width,
      alignment: Alignment.centerLeft,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 30),
        title: Text(
          text,
          style: TextStyle(fontSize: 16, color: Color(0xff605B5B), fontWeight: FontWeight.w500),
        ),
        leading: Icon(
          icon,
          color: color,
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }

  Widget buildName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'hello,',
          style: TextStyle(
            color: Colors.black45,
            fontSize: FontSize.textSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          currentEmployee?.firstName ?? "" + " !",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget buildLine() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        width: 250,
        height: 1,
        color: Colors.grey[300],
      ),
    );
  }
}

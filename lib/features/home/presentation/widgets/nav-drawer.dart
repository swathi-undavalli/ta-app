import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/all-bookings/presentation/screens/all-bookings-screen.dart';
import 'package:temple_adventures/features/boat/presentation/screens/all-boats-page.dart';
import 'package:temple_adventures/features/boat/presentation/screens/newBoat-page.dart';
import 'package:temple_adventures/features/employees/presentation/screens/employee-profile-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/attendance/attendance-page.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/all-activities-screen.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import '../../../../core/authentication/firebase-authentication.dart';
import '../../../admin-portal/presentation/admin-portal-screen.dart';
import '../../../login/presentation/screens/login-page.dart';

class NavDrawer extends StatelessWidget {
  static const String id = "sideMenuWidget";

  @override
  Widget build(BuildContext context) {
    if (currentEmployee == null) {
      return Drawer(
        child: Column(
          children: [
            SizedBox(height: 100),
            buildUserProfile(),
            SizedBox(height: 20),
            buildName(),
            SizedBox(height: 10),
            buildLine(),

            buildMenuItem(
              icon: Icons.logout,
              text: 'Log out',
              onTap: () async {
                await FirebaseAuthentication.logout();
                Get.offAllNamed(LoginScreen.id);
              },
            ),
            // Spacer(),
            buildLine(),
            buildMiniMenuItem(text: 'templeadventures.com'),
            SizedBox(height: 20)
          ],
        ),
      );
    }
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
            buildMenuItem(
              icon: Icons.admin_panel_settings_rounded,
              text: 'Admin Portal',
              onTap: () {
                Get.offAndToNamed(AdminPortalScreen.id);
              },
            ),
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
              text: 'Add Boats',
              onTap: () {
                Get.toNamed(NewBoatPage.id);
              },
            ),
            buildMenuItem(
              icon: Icons.houseboat_rounded,
              text: 'All Boats',
              onTap: () {
                Get.toNamed(AllBoatsPage.id);
              },
            ),
            // buildMenuItem(
            //   icon: Icons.logout,
            //   text: 'Log out',
            //   onTap: () async {
            //     await FirebaseAuthentication.logout();
            //     Get.offAllNamed(LoginScreen.id);
            //   },
            // ),
            // Spacer(),
            buildLine(),
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

  Widget buildMiniMenuItem({@required text}) {
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
      {@required IconData icon, @required String text, Color color = Colors.black87, @required Function onTap}) {
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
        onTap: onTap,
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
        if (currentEmployee != null)
          Text(
            currentEmployee.firstName + " !",
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

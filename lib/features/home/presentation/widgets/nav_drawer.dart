import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/services/auto_update.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../Marketing/views/marketing_view.dart';
import '../../../activities/presentation/screens/all_activities_screen.dart';
import '../../../all_bookings/presentation/screens/all_bookings_screen.dart';
import '../../../board_plan/presentation/views/board_plan_view.dart';
import '../../../boat/presentation/screens/manage_general_info.dart';
import '../../../employees/model/employee.dart';
import '../../../employees/presentation/screens/employee_profile_screen.dart';
import '../../../events/views/events_view.dart';
import '../../../logs/presentation/screens/log_screen.dart';

class NavDrawer extends StatelessWidget {
  static const String id = 'sideMenuWidget';
  final AutoUpdateLogic logic = AutoUpdateLogic();

  NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            buildUserProfile(),
            const SizedBox(height: 20),
            buildName(),
            const SizedBox(height: 10),
            buildLine(),
            buildMenuItem(
              icon: Icons.account_circle,
              text: 'Profile',
              onTap: () {
                Get.offAndToNamed(EmployeeProfileScreen.id);
              },
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
              icon: Icons.content_paste,
              text: 'Board Plan',
              onTap: () {
                Get.offAndToNamed(BoardPlanView.id);
              },
            ),
            buildMenuItem(
              icon: Icons.scuba_diving_rounded,
              text: 'General Info',
              onTap: () {
                Get.toNamed(ManageGeneralInfo.id);
              },
            ),
            EmployeeAccess(
              access: AccessRights.marketingGallery,
              child: buildMenuItem(
                icon: Icons.collections_bookmark_rounded,
                text: 'Marketing Gallery',
                onTap: () {
                  Get.offAndToNamed(MarketingView.id);
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.event_rounded,
              text: 'Upcoming Events',
              onTap: () {
                Get.offAndToNamed(EventsView.id);
              },
            ),
            EmployeeAccess(
              access: AccessRights.editActivityPrices,
              child: buildMenuItem(
                icon: Icons.edit,
                text: 'Programs List',
                onTap: () {
                  Get.offAndToNamed(AllActivitiesScreen.id);
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
            buildLine(),
            (logic.controller.version != null && logic.controller.buildNumber != null)
                ? buildMiniMenuItem(
                    text: "Version : ${"${logic.controller.version!}+${logic.controller.buildNumber!}"}",
                  )
                : buildMiniMenuItem(text: 'Loading version number...'),
            buildMiniMenuItem(text: 'templeadventures.com'),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  ///================Business logic==================///

  Widget buildUserProfile() {
    return const SizedBox(
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
          style: const TextStyle(color: Colors.black45, fontSize: FontSize.small),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String text,
    Color color = Colors.black87,
    required Function onTap,
  }) {
    return Container(
      width: Get.width,
      alignment: Alignment.centerLeft,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 30),
        title: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Color(0xff605B5B), fontWeight: FontWeight.w500),
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
        const Text(
          'hello,',
          style: TextStyle(
            color: Colors.black45,
            fontSize: FontSize.textSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          currentEmployee?.firstName ?? '' ' !',
          style: const TextStyle(
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

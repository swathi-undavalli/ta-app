import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/services/auto_update.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../activities/presentation/views/all_activities_view.dart';
import '../../../all_bookings/presentation/views/all_bookings_view.dart';
import '../../../board_plan/presentation/views/board_plan_view.dart';
import '../../../certifications/presentation/views/certification_logs_view.dart';
import '../../../coast_guard_slip/presentation/views/coast_guard_slip_view.dart';
import '../../../dive_logs/presentation/views/customer_logs_view.dart';
import '../../../employees/model/employee.dart';
import '../../../employees/presentation/views/employee_profile_view.dart';
import '../../../equipment/presentation/views/all_equipment_view.dart';
import '../../../events/presentation/views/events_view.dart';
import '../../../general_info/presentation/views/general_info_view.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../../offers/presentation/views/offers_view.dart';
import '../../../roaster/presentation/views/roaster_view.dart';
import '../../../screen_saver/views/marketing_view.dart';

class NavDrawer extends StatelessWidget {
  static const String id = 'sideMenuWidget';
  final AutoUpdateLogic logic = AutoUpdateLogic();

  NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    if (currentEmployee?.role == 'Intern') {
      return const SizedBox();
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Spacing.h100,
            buildUserProfile(),
            Spacing.h20,
            buildName(),
            Spacing.h30,
            buildLine(),
            Spacing.h10,
            buildMenuItem(
              icon: Icons.account_circle,
              text: 'Profile',
              onTap: () {
                Navigator.push(context, EmployeeProfileView.route());
              },
            ),
            EmployeeAccess(
              access: AccessRights.viewBookings,
              child: buildMenuItem(
                icon: Icons.add_to_photos_sharp,
                text: 'All Bookings',
                onTap: () {
                  Navigator.push(context, AllBookingsView.route());
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.content_paste,
              text: 'Board Plan',
              onTap: () {
                Navigator.push(context, BoardPlanView.route());
              },
            ),
            buildMenuItem(
              icon: Icons.scuba_diving_rounded,
              text: 'General Info',
              onTap: () {
                Navigator.push(context, GeneralInfoView.route());
              },
            ),
            EmployeeAccess(
              access: AccessRights.marketingGallery,
              child: buildMenuItem(
                icon: Icons.collections_bookmark_rounded,
                text: 'Marketing Gallery',
                onTap: () {
                  Navigator.push(context, MarketingView.route());
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.event_rounded,
              text: 'Upcoming Events',
              onTap: () {
                Navigator.push(context, EventsView.route());
              },
            ),
            EmployeeAccess(
              access: AccessRights.offers,
              child: buildMenuItem(
                icon: Icons.percent,
                text: 'Offers',
                onTap: () {
                  Navigator.push(context, OffersView.route());
                },
              ),
            ),
            EmployeeAccess(
              access: AccessRights.editActivityPrices,
              child: buildMenuItem(
                icon: Icons.edit,
                text: 'Programs List',
                onTap: () {
                  Navigator.push(context, AllActivitiesView.route());
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.directions_boat,
              text: 'Coast Guard Slip',
              onTap: () {
                Navigator.push(context, CoastGuardSlipView.route());
              },
            ),
            buildMenuItem(
              icon: Icons.add_card_rounded,
              text: 'Roaster',
              onTap: () {
                Navigator.push(context, RoasterView.route());
              },
            ),
            buildMenuItem(
              icon: Icons.branding_watermark,
              text: 'Manage Equipment',
              onTap: () {
                Navigator.push(context, AllEquipmentView.route());
              },
            ),
            buildMenuItem(
              icon: Icons.book_rounded,
              text: 'Logs',
              onTap: () {
                Navigator.push(context, LogView.route());
              },
            ),
            EmployeeAccess(
              access: AccessRights.offers,
              child: buildMenuItem(
                icon: Icons.collections_bookmark_rounded,
                text: 'Customer Dive Logs',
                onTap: () {
                  Navigator.push(context, CustomerLogsView.route());
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.card_membership_outlined,
              text: 'Certifications',
              onTap: () {
                Navigator.push(context, CertificationLogsView.route());
              },
            ),
            buildLine(),
            (logic.controller.version != null && logic.controller.buildNumber != null)
                ? buildMiniMenuItem(
                    text: "Version : ${"${logic.controller.version!}+${logic.controller.buildNumber!}"}",
                  )
                : buildMiniMenuItem(text: 'Loading version number...'),
            buildMiniMenuItem(text: 'templeadventures.com'),
            Spacing.h20,
          ],
        ),
      ),
    );
  }

  ///================Business logic==================///

  Widget buildUserProfile() {
    return const SizedBox(
      height: 50,
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
      width: Screen.width,
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
        Spacing.h10,
        Text(
          '${currentEmployee?.name} !',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget buildLine() {
    return Container(
      width: Screen.width,
      height: 1,
      color: Colors.grey[300],
    ).paddingSymmetric(horizontal: 20);
  }
}

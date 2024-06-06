import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/services/auto_update.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../activities/presentation/views/all_activities_view.dart';
import '../../../all_bookings/presentation/views/all_bookings_view.dart';
import '../../../board_plan/presentation/views/board_plan_view.dart';
import '../../../bookings/presentation/views/customer_logs_view.dart';
import '../../../certifications/presentation/views/certification_progress_view.dart';
import '../../../coast_guard_slip/presentation/views/coast_guard_slip_view.dart';
import '../../../employees/model/employee.dart';
import '../../../employees/presentation/views/employee_profile_view.dart';
import '../../../events/presentation/views/events_view.dart';
import '../../../general_info/presentation/views/general_info_view.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../../offers/presentation/views/offers_view.dart';
import '../../../screen_saver/views/marketing_view.dart';

class NavDrawer extends StatelessWidget {
  static const String id = 'sideMenuWidget';
  final AutoUpdateLogic logic = AutoUpdateLogic();

  NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Get.offAndToNamed(EmployeeProfileView.id);
              },
            ),
            EmployeeAccess(
              access: AccessRights.viewBookings,
              child: buildMenuItem(
                icon: Icons.add_to_photos_sharp,
                text: 'All Bookings',
                onTap: () {
                  Get.offAndToNamed(AllBookingsView.id);
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
                Get.toNamed(GeneralInfoView.id);
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
              access: AccessRights.offers,
              child: buildMenuItem(
                icon: Icons.percent,
                text: 'Offers',
                onTap: () {
                  Get.offAndToNamed(OffersView.id);
                },
              ),
            ),
            EmployeeAccess(
              access: AccessRights.editActivityPrices,
              child: buildMenuItem(
                icon: Icons.edit,
                text: 'Programs List',
                onTap: () {
                  Get.offAndToNamed(AllActivitiesView.id);
                },
              ),
            ),
            buildMenuItem(
              icon: Icons.directions_boat,
              text: 'Coast Guard Slip',
              onTap: () {
                Get.offAndToNamed(CoastGuardSlipView.id);
              },
            ),
            // buildMenuItem(
            //   icon: Icons.add_card_rounded,
            //   text: 'Roaster',
            //   onTap: () {
            //     Get.offAndToNamed(RoasterView.id);
            //   },
            // ),
            buildMenuItem(
              icon: Icons.book_rounded,
              text: 'Logs',
              onTap: () {
                Get.offAndToNamed(LogView.id);
              },
            ),
            EmployeeAccess(
              access: AccessRights.offers,
              child: buildMenuItem(
                icon: Icons.collections_bookmark_rounded,
                text: 'Customer logs',
                onTap: () {
                  Get.offAndToNamed(CustomerLogsView.id);
                },
              ),
            ),
            EmployeeAccess(
              access: AccessRights.processCertificate,
              child: buildMenuItem(
                icon: Icons.card_membership_outlined,
                text: 'Certifications',
                onTap: () {
                  Get.offAndToNamed(CertificationProgressView.id);
                },
              ),
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
      width: Get.width,
      height: 1,
      color: Colors.grey[300],
    ).paddingSymmetric(horizontal: 20);
  }
}

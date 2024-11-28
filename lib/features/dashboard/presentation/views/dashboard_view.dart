import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/services/notification_service.dart';
import '../../../boat/presentation/views/boats_view.dart';
import '../../../bookings/presentation/views/booking_view.dart';
import '../../../conditions/presentation/views/conditions_view.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../home/presentation/widgets/nav_drawer.dart';
import '../../controller/dashboard_controller.dart';

late DashBoardScreenLogic dashboardLogic;

// ignore: must_be_immutable
class DashBoardView extends StatefulWidget {
  DashBoardView({super.key}) {
    dashboardLogic = DashBoardScreenLogic();
  }

  static Route route() => MaterialPageRoute(
        builder: (context) => DashBoardView(),
      );

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  final screens = [
    const HomeView(),
    BoatsView(),
    BookingView(),
    const ConditionsView(),
  ];

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    ///app is in Terminated
    FirebaseNotificationService.handleTerminatedNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (dashboardLogic.controller.currentIndex == 2) {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
          FocusNode().requestFocus();
          DateTime now = DateTime.now();
          if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: 'Press Double tap to exit');
            return Future.value(false);
          }
          return Future.value(true);
        } else {
          return true;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background.lightBlue,
            bottomNavigationBar: buildBottomNavigationBar(),
            drawer: NavDrawer(),
            body: SafeArea(
              child: buildSelectedPage(),
            ),
          ),
          buildShowLoading(),
        ],
      ),
    );
  }

  ///===============UI=================///

  Widget buildShowLoading() {
    return GetBuilder<DashBoardScreenController>(
      builder: (controller) {
        if (controller.showLoading) {
          return Material(
            color: Colors.transparent,
            child: Container(
              color: Colors.black54,
              height: Screen.height,
              width: Screen.width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildSelectedPage() {
    return GetBuilder<DashBoardScreenController>(
      builder: (controller) {
        return screens[controller.currentIndex];
      },
    );
  }

  Widget buildBottomNavigationBar() {
    return GetBuilder<DashBoardScreenController>(
      builder: (controller) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          iconSize: 30,
          currentIndex: controller.currentIndex,
          onTap: (index) {
            controller.currentIndex = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage('images/taHomeWhite.png')),
              activeIcon: buildActiveIcon('images/taHomeBlack.png'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage('images/boatWhite.png')),
              activeIcon: buildActiveIcon('images/boat_black.png'),
              label: 'boat',
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage('images/taCalWhite.png')),
              activeIcon: buildActiveIcon('images/taCalBlack.png'),
              label: 'bookings',
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage('images/taCloudWhite.png')),
              activeIcon: buildActiveIcon('images/taCloudBlack.png'),
              label: 'weather',
            ),
          ],
        );
      },
    );
  }

  Widget buildActiveIcon(String image) {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Image.asset(image),
    );
  }
}

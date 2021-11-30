import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/presentation/screens/boat-page.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/booking-screen.dart';
import 'package:temple_adventures/features/dashboard/controller/dashboard-controller.dart';
import 'package:temple_adventures/features/home/presentation/screens/home-page.dart';
import 'package:temple_adventures/features/home/presentation/widgets/nav-drawer.dart';
import 'package:temple_adventures/features/weather/presentation/screens/weather-page.dart';
final GlobalKey<ScaffoldState> dashboardDrawerKey = GlobalKey();

class DashBoardScreen extends StatelessWidget {
  static const String id = "DashBoardScreen";
  final screens = [
    HomePage(),
    WeatherPage(),
    BookingScreen(),
    BoatPage(),
  ];

  final DashBoardScreenLogic logic = DashBoardScreenLogic();


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(),
          drawer: NavDrawer(),
          key: dashboardDrawerKey,
          body: SafeArea(
            child: buildSelectedPage(),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  ///===============UI=================///

  Widget buildShowLoading() {
    return GetBuilder<DashBoardScreenController>(builder: (controller) {
      if (controller.showLoading)
        return Container(
          color: Colors.black54,
          height: Get.height,
          width: Get.width,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
        );
      else
        return Container();
    });
  }

  Widget buildSelectedPage() {
    return GetBuilder<DashBoardScreenController>(builder: (controller) {
      return screens[controller.currentIndex];
    });
  }

  Widget buildBottomNavigationBar() {
    return GetBuilder<DashBoardScreenController>(builder: (controller) {
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
            icon: ImageIcon(AssetImage('images/taHomeWhite.png')),
            // icon: Icon(Icons.home_outlined),
            activeIcon: buildActiveIcon('images/taHomeBlack.png'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/taCloudWhite.png')),
            activeIcon: buildActiveIcon('images/taCloudBlack.png'),
            label: 'weather',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/taCalWhite.png')),
            activeIcon: buildActiveIcon('images/taCalBlack.png'),
            label: 'bookings',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/boat.png')),
            activeIcon: buildActiveIcon('images/boat_black.png'),
            label: 'boat',
          ),
        ],
      );
    });
  }

  Widget buildActiveIcon(String image) {
    return Container(
      height: 30,
      width: 30,
      child: Image.asset(image),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    );
  }
}

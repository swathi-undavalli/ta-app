import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/all-bookings/controller/all-bookings-controller.dart';

class AllBookingsScreen extends StatelessWidget {

  static const String id = "AllBookingsScreen";

  final AllBookingsLogic logic = AllBookingsLogic();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            centerTitle: true,
            title: buildTitle(),
            leading: BackNavigationIcon(),
            elevation: 0,
            backgroundColor: AppColors.background.white,
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: GetBuilder<AllBookingsController>(builder: (controller) {
                if (!controller.showLoading)
                  return MyExpansionPanel(items: controller.bookings);
                else
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
              }),
            ),
          ),
        ),
        buildShowLoading()
      ],
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<AllBookingsController>(builder: (controller) {
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
        return SizedBox();
    });
  }

  Widget buildTitle() {
    return Text(
      'All Bookings',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.0,
      ),
    );
  }

}

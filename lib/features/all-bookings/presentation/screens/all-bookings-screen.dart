import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/all-bookings/controller/all-bookings-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class AllBookingsScreen extends StatelessWidget {
  static const String id = "AllBookingsScreen";
  AllBookingsLogic logic = AllBookingsLogic();

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
                return Column(
                  children: [
                    SizedBox(height: 20),
                    // buildAllBookings(),
                    buildBookings(),
                    // Spacer(),
                    // buildAllPages(),
                    SizedBox(height: 30)
                  ],
                );
              }),
            ),
          ),
        ),
        buildShowLoading()
      ],
    );
  }

  // Widget buildAllBookings() {
  //   return GetBuilder<AllBookingsController>(builder: (controller) {
  //     controller.bookings = [];
  //     return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ...List.generate(108,
  //               (index) => buildListTile((index + 1).toString())),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> buildListTile(
  //     String id) {
  //   return FutureBuilder(
  //       future: FirebaseFirestore.instance.collection("bookings").doc(id).get(),
  //       builder: (BuildContext context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: Container(
  //               height: 50,
  //               width: Get.width,
  //               child: Shimmer.fromColors(
  //                 child: Container(
  //                   height: 50,
  //                   width: Get.width,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(5),
  //                       color: Colors.grey),
  //                 ),
  //                 baseColor: Colors.grey[300],
  //                 highlightColor: Colors.grey[100],
  //               ),
  //             ),
  //           );
  //         }
  //         try {
  //           Map<String, dynamic> bookingData = snapshot.data.data();
  //           BookingModel booking = BookingModel.fromMap(bookingData);
  //           var e = ItemModel.fromBookings(booking);
  //           // logic.controller.bookings.add(e);
  //           return buildBookings(e);
  //         } catch (e) {
  //           return SizedBox();
  //         }
  //       });
  // }

  Widget buildBookings() {
    return GetBuilder<AllBookingsController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
        child: BookingsExpansionPanel(
          items: controller.bookings,
          onDeletePressed: () {
            logic.getBookings();
          },
        ),
      );
    });
  }

  Widget buildAllPages() {
    getCircleColor(int index, AllBookingsController controller) {
      if (controller.selectedPage == controller.pages[index])
        return AppColors.background.lightSkyBlue;
      return AppColors.background.white;
    }

    return GetBuilder<AllBookingsController>(builder: (controller) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: Get.width / 2,
          child: ListView.builder(
            itemCount: controller.pages.length,
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    controller.selectedPage = controller.pages[index];
                    log(controller.selectedPage);
                  },
                  child: Container(
                    height: 25,
                    width: 25,
                    child: Center(
                        child: Text(
                      controller.pages[index],
                      style: TextStyle(
                          color: AppColors.background.black,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w600),
                    )),
                    decoration: BoxDecoration(
                        color: getCircleColor(index, controller),
                        shape: BoxShape.circle),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget buildShowLoading() {
    return GetBuilder<AllBookingsController>(builder: (controller) {
      if (controller.showLoading)
        return Container(
          color: Colors.white,
          height: Get.height,
          width: Get.width,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.black,
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

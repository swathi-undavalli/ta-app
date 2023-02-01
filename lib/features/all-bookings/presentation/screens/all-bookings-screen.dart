import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/all-bookings/controller/all-bookings-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/all-booking-expansionPanel.dart';

class AllBookingsScreen extends StatelessWidget {
  static const String id = "AllBookingsScreen";
  AllBookingsLogic logic = AllBookingsLogic();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            logic.controller.searchTED.text = "";
            return true;
          },
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                centerTitle: true,
                title: buildTitle(),
                leading: TextButton(
                  onPressed: () {
                    logic.controller.searchTED.text = "";
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.text.black,
                    size: 17,
                  ),
                ),
                elevation: 0,
                backgroundColor: AppColors.background.white,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    buildSearchBar(),
                    SizedBox(height: 10),
                    buildCheckFirebase(),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget buildCheckFirebase() {
    return Expanded(
      child: GetBuilder<AllBookingsController>(builder: (controller) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                BookingModel booking = BookingModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                // log(booking.id);
                if (controller.searchTED.text.isNotEmpty) {
                  if (booking.id!.contains(controller.searchTED.text) ||
                      (booking.pax![0]['first-name'] as String)
                          .toLowerCase()
                          .contains(
                          controller.searchTED.text.toLowerCase().trim()))
                    return AllBookingsExpansionPanel(booking: booking);
                  return SizedBox();
                }
                return AllBookingsExpansionPanel(booking: booking);
              },
              // children: snapshot.data.docs.map((document) {
              //   BookingModel booking = BookingModel.fromMap(document.data());
              //   // log(booking.id);
              //   if (controller.searchTED.text.isNotEmpty) {
              //     if (booking.id.contains(controller.searchTED.text) ||
              //         (booking.pax[0]['first-name'] as String)
              //             .toLowerCase()
              //             .contains(
              //                 controller.searchTED.text.toLowerCase().trim()))
              //       return AllBookingsExpansionPanel(booking: booking);
              //     return SizedBox();
              //   }
              //   return AllBookingsExpansionPanel(booking: booking);
              // }).toList(),
            );
          },
        );
      }),
    );
  }

  Widget buildSearchBar() {
    return Container(
      width: 328,
      height: 47,
      decoration: BoxDecoration(
          color: AppColors.background.white,
          borderRadius: BorderRadius.circular(5)),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            SizedBox(width: 15),
            Container(
              width: 240,
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search...',
                    hintStyle:
                        TextStyle(fontSize: FontSize.textSize, height: 1)),
                controller: logic.controller.searchTED,
                onChanged: (text) {
                  logic.controller.update();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBookingExpansionPanel(BookingModel booking) => Text(booking.id!);

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
                    //log(controller.selectedPage);
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

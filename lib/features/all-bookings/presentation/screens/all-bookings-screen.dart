import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/all-bookings/controller/all-bookings-controller.dart';

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
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    buildSearchBar(),
                    // buildAllBookings(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          logic.controller.showSuggestions = false;
                        },
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                buildBookings(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Spacer(),
                    // buildAllPages(),
                  ],
                ),
                buildSuggestions(),
              ],
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
  Widget buildSuggestions() {
    return GetBuilder<AllBookingsController>(builder: (controller) {
      if (controller.showSuggestions)
        return Positioned(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 300,
              minWidth: 328,
              maxWidth: 328,
            ),
            margin: EdgeInsets.only(
              top: 65,
              left: (Get.width - 328) / 2,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ]),
            padding: const EdgeInsets.only(top: 10),
            child: controller.suggestionsList.isEmpty
                ? Container(
                    height: 100,
                    child: Center(
                      child: Text("No results found"),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: controller.suggestionsList
                          .map(
                            (e) => BookingsExpansionPanel(
                              items: [e],
                              onDeletePressed: () {
                                logic.getBookings();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        );
      return SizedBox();
    });
  }

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
                  if (text.isNotEmpty) {
                    logic.controller.showSuggestions = true;
                    logic.updateSearchListByID(text);
                  } else {
                    logic.controller.showSuggestions = false;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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

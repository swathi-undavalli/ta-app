import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class BookingsCalenderWidget extends StatelessWidget {
  final void Function(DateTime) onDateTimeSelected;
  final bool isDiveSession;
  final bool showDetails;
  DateTime startDate;
  final bool highlightInvalidTime;
  final FilterType calenderType;
  final AutoScrollController autoScrollController;

  BookingsCalenderWidget({
    @required this.onDateTimeSelected,
    this.isDiveSession = false,
    this.showDetails = false,
    this.startDate,
    this.highlightInvalidTime = false,
    this.calenderType,
    @required this.autoScrollController,
  }) {
    print("new instance");
    if (startDate == null) startDate = DateTime.now();
    startDate = startDate.subtract(Duration(days: 1));
    logic.controller.startDate = startDate;
    logic.controller.showDetails = showDetails;
    logic.controller.isDiveSession = isDiveSession;
    logic.controller.calenderType = calenderType;
    logic.getDates();
    if (showDetails)
      EmployeeAccess.run(
          function: autoCenterDaySelector, access: AccessRights.viewBookings);
    else
      EmployeeAccess.run(
          function: scrollToSelectedDate, access: AccessRights.viewBookings);
  }

  scrollToIndex(int index) {
    autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
  }

  final BookingsCalenderWidgetLogic logic = BookingsCalenderWidgetLogic();

  Future<void> autoCenterDaySelector() async {
    await Future.delayed(Duration(microseconds: 500));
    scrollToIndex(50);
    logic.onDateSelected(50);
  }

  Future<void> scrollToSelectedDate() async {
    await Future.delayed(Duration(microseconds: 500));
    int index = startDate.difference(logic.controller.selectedDate).inDays;
    log("index === ${index.abs()}");
    scrollToIndex(index.abs());
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeAccess(
      access: AccessRights.viewBookings,
      showMessage: true,
      child:
          GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
        return Column(
          children: [
            buildDaySelector(),
            if (showDetails) SizedBox(height: 20),
            buildTimeTable(),
            buildBookingDetails(),
            SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  ///==================UI===================///

  Widget buildBookingDetails() {
    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      if (showDetails)
        return Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                buildTabButton("Theory", () {
                  controller.selectedType = FilterType.Theory;
                },
                    count: controller.theoryCountN,
                    enable: controller.selectedType == FilterType.Theory,
                    color: Colors.orangeAccent),
                buildTabButton("Pool", () {
                  controller.selectedType = FilterType.Pool;
                },
                    count: controller.poolCountN,
                    enable: controller.selectedType == FilterType.Pool,
                    color: Colors.green),
                buildTabButton("Dive", () {
                  controller.selectedType = FilterType.Dive;
                },
                    count: controller.diveCountN,
                    enable: controller.selectedType == FilterType.Dive,
                    color: Colors.lightBlueAccent),
              ],
            ),
            SizedBox(height: 20),
            buildBookingsList(),
          ],
        );
      else
        return SizedBox();
    });
  }

  Widget buildTabButton(
    String title,
    Function onTap, {
    bool enable = false,
    Color color,
    int count,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: enable ? AppColors.background.skyBlue : Colors.white,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.small,
                    color: enable ? Colors.white : Colors.black,
                  ),
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "$count",
                      style: TextStyle(
                        color: color,
                        fontSize: FontSize.small - 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimeTable() {
    logic.getTime();
    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      return Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.background.white,
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      buildTitle("Bookings"),
                      controller.showLoading
                          ? SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                color: AppColors.background.black,
                                strokeWidth: 1,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     buildSessionCount(
                  //         session: "T",
                  //         count: controller.totalTheoryPax,
                  //         color: Colors.orangeAccent),
                  //     buildSessionCount(
                  //         session: "P",
                  //         count: controller.totalPoolPax,
                  //         color: Colors.green),
                  //     buildSessionCount(
                  //         session: "D",
                  //         count: controller.totalDivePax,
                  //         color: Colors.lightBlueAccent),
                  //   ],
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Wrap(
                  spacing: 0,
                  runSpacing: 5,
                  children: controller.timeTable
                      .map((date) => buildTimings(date))
                      .toList()),
            ),
            if (!controller.showLoading)
              Column(
                children: [
                  Center(
                    child: Container(
                      child: (controller.poolCount == 0 &&
                              controller.theoryCount == 0 &&
                              controller.diveCount == 0 &&
                              showDetails)
                          ? Text(
                              "No Bookings Found",
                              style: TextStyle(fontSize: 15),
                            )
                          : SizedBox(),
                    ),
                  ),
                  // SizedBox(height: 10),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget buildSessionCount({String session, int count, Color color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5),
      child: Row(
        children: [
          Text(
            "$session: ",
            style: TextStyle(
                color: AppColors.text.black,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          Text(
            "$count ",
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildBookingsList() {
    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      print(controller.bookings);
      List<ItemModel> expansionList = [];
      if (controller.selectedType == null)
        expansionList = controller.expansionItemModels;
      else if (controller.selectedType == FilterType.Theory) {
        controller.expansionItemModels.forEach((element) {
          if (element.session.contains("Theory")) expansionList.add(element);
          var count = 0;
          expansionList.forEach((element) {
            count += element.pax;
          });
          controller.theoryCountN = count;
          controller.theoryCount = expansionList.length;
        });
      } else if (controller.selectedType == FilterType.Pool) {
        controller.expansionItemModels.forEach((element) {
          if (element.session.contains("Pool")) expansionList.add(element);
          var count = 0;
          expansionList.forEach((element) {
            count += element.pax;
          });
          controller.poolCountN = count;
          controller.poolCount = expansionList.length;
        });
      } else if (controller.selectedType == FilterType.Dive) {
        controller.expansionItemModels.forEach((element) {
          if (element.session.contains("Dive")) expansionList.add(element);
          var count = 0;
          expansionList.forEach((element) {
            count += element.pax;
          });
          controller.diveCountN = count;
          controller.diveCount = expansionList.length;
        });
      }
      if (showDetails)
        return BookingsExpansionPanel(
          items: expansionList,
          onDeletePressed: () {},
        );
      return SizedBox();
    });
  }

  Widget buildDetails(String text) {
    return Container(
      height: 15,
      child: Text(
        text,
        style: TextStyle(
            color: AppColors.text.darkgrey,
            fontSize: 10,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget buildTitle(String text) {
    return Container(
      // padding: const EdgeInsets.only(left: 20, right: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.nunito),
      ),
    );
  }

  Widget buildTimings(DateTime date) {
    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      getCircleColor(BookingsCalenderWidgetController controller) {
        if (controller.selectedDate == date)
          return AppColors.background.skyBlue;
        if (highlightInvalidTime &&
            DateTime.now().difference(date).inSeconds > 0)
          return AppColors.background.grey;
      }

      Widget num = getEventsCount(controller, date);
      if (num == null && showDetails) return SizedBox();
      return GestureDetector(
        onTap: () {
          if (highlightInvalidTime &&
              DateTime.now().difference(date).inSeconds > 0) {
            showToast("Invalid Date");
          } else {
            controller.selectedDate = date;
            print("Selected Date : ${controller.selectedDate}");
            logic.filterBookingsList();
            onDateTimeSelected(controller.selectedDate);
          }

          //   controller.theoryCount = 0;
          //   controller.poolCount = 0;
          //   controller.diveCount = 0;
          //
          //   controller.bookings.forEach(
          //     (booking) {
          //       booking.theoryDate.forEach((date) {
          //         print("theory loop");
          //         if (checkDate(date, controller.selectedDate)) {
          //           controller.theoryCount += booking.noOfPersons;
          //         }
          //       });
          //       booking.poolDate.forEach((date) {
          //         print("theory loop");
          //         if (checkDate(date, controller.selectedDate)) {
          //           controller.poolCount += booking.noOfPersons;
          //         }
          //       });
          //       booking.diveDate.forEach((date) {
          //         print("theory loop");
          //         if (checkDate(date, controller.selectedDate)) {
          //           controller.theoryCount += booking.noOfPersons;
          //         }
          //       });
          //     },
          //   );
        },
        child: Stack(
          children: [
            Container(
              width: 42,
              height: 42,
              color: Colors.white,
              child: Center(
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: getCircleColor(controller),
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: (date.minute == 0)
                            ? DateFormat("hh").format(date)
                            : DateFormat("hh:mm").format(date),
                        style: TextStyle(
                            color: AppColors.text.black,
                            fontFamily: AppFonts.nunito,
                            fontSize: 10),
                        children: <TextSpan>[
                          TextSpan(
                            text: (date.minute == 0)
                                ? DateFormat(" a").format(date)
                                : DateFormat("\na").format(date),
                            style: TextStyle(fontSize: 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: num ?? SizedBox(),
            ),
          ],
        ),
      );
    });
  }

  bool isSameDates(DateTime a, DateTime b) {
    return (a.day == b.day && a.month == b.month && a.year == b.year);
  }

  Widget buildDaySelector() {
    getDotColor(int index, BookingsCalenderWidgetController controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.green;
      return isSameDates(controller.calenderDates[index], DateTime.now())
          ? AppColors.background.skyBlue
          : AppColors.background.grey;
    }

    getDateColor(int index, BookingsCalenderWidgetController controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.white;
      return AppColors.background.black;
    }

    getDayColor(int index, BookingsCalenderWidgetController controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.white;
      return AppColors.background.black;
    }

    getBoxColor(int index, BookingsCalenderWidgetController controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.black;
      return isSameDates(controller.calenderDates[index], DateTime.now())
          ? AppColors.background.datesBlue
          : AppColors.background.white;
    }

    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      return Container(
        height: 100,
        width: Get.width,
        child: ListView.builder(
            itemCount: 400,
            controller: autoScrollController,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return AutoScrollTag(
                controller: autoScrollController,
                key: ValueKey(index),
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      print("======Started");
                      logic.controller.lastSelectedIndex = index;
                      logic.onDateSelected(index);
                      scrollToIndex(index);
                    },
                    child: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                        color: getBoxColor(index, controller),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              DateFormat('MMM')
                                  .format(controller.calenderDates[index]),
                              style: TextStyle(
                                  color: getDotColor(index, controller),
                                  fontSize: FontSize.small,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              controller.calenderDates[index].day.toString(),
                              style: TextStyle(
                                  color: getDateColor(index, controller),
                                  fontSize: FontSize.textSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('EE')
                                  .format(controller.calenderDates[index]),
                              style: TextStyle(
                                  color: getDayColor(index, controller),
                                  fontSize: FontSize.small,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }

  Widget getEventsCount(
      BookingsCalenderWidgetController controller, DateTime date) {
    var show = false;
    int totalBookings = 0;

    controller.bookings.forEach((booking) {
      var allBookingsList = [];
      allBookingsList.addAll(booking.diveDate);
      allBookingsList.addAll(booking.poolDate);
      allBookingsList.addAll(booking.theoryDate);
      allBookingsList.forEach((bookingDate) {
        if (isSameMinute(date, bookingDate)) {
          print("++++++++++++++++++++:)");
          print(booking.id);
          print(booking.noOfPersons);
          totalBookings += booking.noOfPersons;
          show = true;
        }
      });
    });

    // int totalPax = 0;
    // for (DateTime booking in logic.controller.bookingTimings) {
    //   if (controller.isDiveSession) {
    //     if (booking.hour == date.hour &&
    //         booking.day == date.day &&
    //         booking.minute == date.minute) {
    //       totalBookings++;
    //       show = true;
    //     }
    //   } else {
    //     if (booking.hour == date.hour && booking.day == date.day) {
    //       totalBookings++;
    //       show = true;
    //     }
    //   }
    // }
    if (show)
      return Container(
        height: 12,
        width: 12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.background.skyBlue)),
        child: Center(
          child: Text(
            totalBookings.toString(),
            style: TextStyle(fontSize: 8),
          ),
        ),
      );
    else
      return null;
  }

  Widget getPAXCount(
      BookingsCalenderWidgetController controller, DateTime date) {
    var show = false;
    int totalBookings = 0;
    int totalPax = 0;

    for (BookingModel booking in controller.bookings) {
      print("=====================hell");
      var list = [];
      if (booking.diveDate != null) {
        list.addAll(booking.diveDate);
      }
      if (booking.poolDate != null) {
        list.addAll(booking.poolDate);
      }
      if (booking.theoryDate != null) {
        list.addAll(booking.theoryDate);
      }

      for (DateTime date in list) {
        if (isSameHour(date, controller.selectedDate)) {
          print(booking.toMap());
        }
      }
    }

    for (DateTime bookingTime in logic.controller.bookingTimings) {
      print("=====================hell");
      if (controller.isDiveSession) {
        if (bookingTime.hour == date.hour &&
            bookingTime.day == date.day &&
            bookingTime.minute == date.minute) {
          totalBookings++;
          show = true;
        }
      } else {
        if (bookingTime.hour == date.hour && bookingTime.day == date.day) {
          totalBookings++;
          show = true;
        }
      }
    }
    if (show)
      return Container(
        height: 12,
        width: 12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.background.skyBlue)),
        child: Center(
          child: Text(
            totalBookings.toString(),
            style: TextStyle(fontSize: 8),
          ),
        ),
      );
    else
      return null;
  }
}

enum FilterType { Theory, Pool, Dive }

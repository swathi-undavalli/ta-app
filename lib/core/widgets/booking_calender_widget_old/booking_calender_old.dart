import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../constants/constants.dart';
import '../../constants/enums.dart';
import '../../util/alignment_extensions.dart';
import '../../util/utils.dart';
import '../access_levels.dart';
import 'bookings_calender_widget_controller_old.dart';

// ignore: must_be_immutable
class BookingsCalenderWidgetOld extends StatelessWidget {
  final void Function(DateTime) onDateTimeSelected;
  final bool isDiveSession;
  final bool showDetails;
  final Function? onSearchTap;
  DateTime startDate;
  final bool highlightInvalidTime;
  final FilterType? calenderType;
  final AutoScrollController? autoScrollController;

  BookingsCalenderWidgetOld({Key? key, 
    required this.onDateTimeSelected,
    this.onSearchTap,
    this.isDiveSession = false,
    this.showDetails = false,
    required this.startDate,
    this.highlightInvalidTime = false,
    this.calenderType,
    required this.autoScrollController,
  }) : super(key: key) {
    startDate = startDate.subtract(const Duration(days: 1));
    logic.controller.startDate = startDate;
    logic.controller.showDetails = showDetails;
    logic.controller.isDiveSession = isDiveSession;
    logic.controller.calenderType = calenderType;
    logic.getDates();
    if (showDetails) {
      //print("1");
      EmployeeAccess.run(
          function: autoCenterDaySelector, access: AccessRights.viewBookings,);
    } else {
      //print("2");
      EmployeeAccess.run(
          function: scrollToSelectedDate, access: AccessRights.viewBookings,);
    }
  }

  scrollToIndex(int index) {
    autoScrollController!
        .scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
  }

  final BookingsCalenderWidgetLogic logic = BookingsCalenderWidgetLogic();

  Future<void> autoCenterDaySelector() async {
    await Future.delayed(const Duration(microseconds: 500));
    scrollToIndex(50);
    logic.onDateSelected(50);
  }

  Future<void> scrollToSelectedDate() async {
    await Future.delayed(const Duration(microseconds: 500));
    int index = startDate.difference(logic.controller.selectedDate).inDays;
    // int index = startDate;
    //log("index === ${index.abs()}");
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
            _buildDaySelector(),
            if (showDetails) const SizedBox(height: 20),
            _buildTimeTable(),
            const SizedBox(height: 20),
          ],
        );
      },),
    );
  }

  Widget _buildTimeTable() {
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
            Row(
              children: [
                _buildTitle('Bookings'),
                const SizedBox(width: 3),
                controller.showLoading
                    ? SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: AppColors.background.black,
                          strokeWidth: 1,
                        ),
                      )
                    : const SizedBox(),
              ],
            ).paddingOnly(top: 15, left: 20, right: 20),
            SizedBox(
              height: 210,
              child: Wrap(
                      spacing: 0,
                      runSpacing: 5,
                      children: controller.timeTable
                          .map((date) => _buildTimings(date))
                          .toList(),)
                  .paddingSymmetric(horizontal: 20, vertical: 7)
                  .scrollable,
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
                          ? const Text(
                              'No Bookings Found',
                              style: TextStyle(fontSize: 15),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    },);
  }

  Widget _buildTitle(String text) {
    return Container(
      // padding: const EdgeInsets.only(left: 20, right: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.nunito,),
      ),
    );
  }

  Widget _buildTimings(DateTime date) {
    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      getCircleColor(BookingsCalenderWidgetController controller) {
        if (controller.selectedDate == date) {
          return AppColors.background.skyBlue;
        }
        if (highlightInvalidTime &&
            DateTime.now().difference(date).inSeconds > 0) {
          return AppColors.background.grey;
        }
      }

      Widget? num = _getEventsCount(controller, date);
      if (num == null && showDetails) return const SizedBox();
      return GestureDetector(
        onTap: () {
          log('1');
          if (highlightInvalidTime &&
              DateTime.now().difference(date).inSeconds > 0) {
            showToast('Invalid Date');
          } else {
            log('2');
            controller.selectedDate = date;
            log('3');
            // logic.filterBookingsList();
            log('4');
            onDateTimeSelected(controller.selectedDate);
          }
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
                      borderRadius: BorderRadius.circular(25),),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: (date.minute == 0)
                            ? DateFormat('hh').format(date)
                            : DateFormat('hh:mm').format(date),
                        style: TextStyle(
                            color: AppColors.text.black,
                            fontFamily: AppFonts.nunito,
                            fontSize: 10,),
                        children: <TextSpan>[
                          TextSpan(
                            text: (date.minute == 0)
                                ? DateFormat(' a').format(date)
                                : DateFormat('\na').format(date),
                            style: const TextStyle(fontSize: 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: num ?? const SizedBox(),
            ),
          ],
        ),
      );
    },);
  }

  bool _isSameDates(DateTime a, DateTime b) {
    return (a.day == b.day && a.month == b.month && a.year == b.year);
  }

  Widget _buildDaySelector() {
    getDotColor(int index, BookingsCalenderWidgetController controller) {
      if (_isSameDates(
          controller.selectedDate, controller.calenderDates[index],)) {
        return Colors.green;
      }
      return _isSameDates(controller.calenderDates[index], DateTime.now())
          ? AppColors.background.skyBlue
          : AppColors.background.grey;
    }

    getDateColor(int index, BookingsCalenderWidgetController controller) {
      if (_isSameDates(
          controller.selectedDate, controller.calenderDates[index],)) {
        return Colors.white;
      }
      return AppColors.background.black;
    }

    getDayColor(int index, BookingsCalenderWidgetController controller) {
      if (_isSameDates(
          controller.selectedDate, controller.calenderDates[index],)) {
        return Colors.white;
      }
      return AppColors.background.black;
    }

    getBoxColor(int index, BookingsCalenderWidgetController controller) {
      if (_isSameDates(
          controller.selectedDate, controller.calenderDates[index],)) {
        return Colors.black;
      }
      return _isSameDates(controller.calenderDates[index], DateTime.now())
          ? AppColors.background.datesBlue
          : AppColors.background.white;
    }

    return GetBuilder<BookingsCalenderWidgetController>(builder: (controller) {
      return SizedBox(
        height: 100,
        width: Get.width,
        child: ListView.builder(
            itemCount: 400,
            controller: autoScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return AutoScrollTag(
                controller: autoScrollController!,
                key: ValueKey(index),
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      //print("======Started");
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
                                  fontWeight: FontWeight.normal,),
                            ),
                            Text(
                              controller.calenderDates[index].day.toString(),
                              style: TextStyle(
                                  color: getDateColor(index, controller),
                                  fontSize: FontSize.textSize,
                                  fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              DateFormat('EE')
                                  .format(controller.calenderDates[index]),
                              style: TextStyle(
                                  color: getDayColor(index, controller),
                                  fontSize: FontSize.small,
                                  fontWeight: FontWeight.normal,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },),
      );
    },);
  }

  Widget? _getEventsCount(
      BookingsCalenderWidgetController controller, DateTime date,) {
    var show = false;
    int totalBookings = 0;

    for (var booking in controller.bookings) {
      var allBookingsList = [];
      allBookingsList.addAll(booking.diveDate!);
      allBookingsList.addAll(booking.poolDate!);
      allBookingsList.addAll(booking.theoryDate!);
      for (var bookingDate in allBookingsList) {
        if (isSameMinute(date, bookingDate)) {
          totalBookings += booking.noOfPersons!;
          show = true;
        }
      }
    }

    if (show) {
      return Container(
        height: 12,
        width: 12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.background.skyBlue),),
        child: Center(
          child: Text(
            totalBookings.toString(),
            style: const TextStyle(fontSize: 8),
          ),
        ),
      );
    } else {
      return null;
    }
  }
}

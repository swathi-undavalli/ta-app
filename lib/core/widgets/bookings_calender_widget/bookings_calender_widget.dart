import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/constants/enums.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/booking-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/widgets/time-picker.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boat-details-bottomSheet.dart';
import '../../../features/boat/models/boats.dart';
import '../../../features/boat/presentation/widgets/customer-expansion-panel.dart';

class BookingsCalenderWidgetNew extends StatelessWidget {
  final void Function(DateTime) onDateTimeSelected;
  final bool isDiveSession;
  final bool showDetails;
  final Function? onSearchTap;
  DateTime startDate;
  final bool highlightInvalidTime;
  final bool isBookingScreen;
  final FilterType? calenderType;
  final AutoScrollController autoScrollController;

  BookingsCalenderWidgetNew({
    required this.onDateTimeSelected,
    this.onSearchTap,
    this.isDiveSession = false,
    this.showDetails = false,
    required this.startDate,
    this.highlightInvalidTime = false,
    this.calenderType,
    required this.autoScrollController,
    required this.isBookingScreen,
  }) {
    if (startDate == null) {
      startDate = DateTime.now();
    }
    startDate = startDate.subtract(Duration(days: 1));
    logic.controller.startDate = startDate;
    logic.controller.showDetails = showDetails;
    logic.controller.isDiveSession = isDiveSession;
    logic.controller.calenderType = calenderType;
    logic.getDates();
    if (showDetails) {
      //print("1");
      EmployeeAccess.run(
          function: autoCenterDaySelector, access: AccessRights.viewBookings);
    } else {
      //print("2");
      EmployeeAccess.run(
          function: scrollToSelectedDate, access: AccessRights.viewBookings);
    }
  }

  scrollToIndex(int index) {
    autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
  }

  final BookingsCalenderWidgetLogicNew logic = BookingsCalenderWidgetLogicNew();

  Future<void> autoCenterDaySelector() async {
    await Future.delayed(Duration(microseconds: 500));
    scrollToIndex(50);
    logic.onDateSelected(50);
  }

  Future<void> scrollToSelectedDate() async {
    await Future.delayed(Duration(microseconds: 500));
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
      child: GetBuilder<BookingsCalenderWidgetControllerNew>(
          builder: (controller) {
        return Column(
          children: [
            _buildDaySelector(),
            if (showDetails) SizedBox(height: 20),
            _buildBookingTypeSelector(),
            SizedBox(height: 15),
            if (showDetails && !isBookingScreen)
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('dailyBoats')
                      .doc(DateFormat("dd-MM-yyyy")
                          .format(controller.selectedDate))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      );
                    }
                    final data = snapshot.data?.data();

                    if (data == null) {
                      return Text(
                        'No boats are added yet',
                      );
                    }

                    BoatsModel? boatsModel =
                        BoatsModel.fromJson(data as Map<String, dynamic>);

                    if ((boatsModel.boats ?? []).isEmpty) {
                      return Text(
                        'No boats are added yet',
                      );
                    }

                    boatsModel.boats!.sort((a1, b1) {
                      DateTime? a = TimePicker.getDateTime(a1.time);
                      DateTime? b = TimePicker.getDateTime(b1.time);
                      if (a == null && b == null) {
                        return 0;
                      } else if (a == null) {
                        return 1;
                      } else if (b == null) {
                        return -1;
                      } else {
                        return a.compareTo(b);
                      }
                    });

                    return Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadiusDirectional.circular(10),
                      ),
                      child: Wrap(
                          children: (boatsModel.boats ?? [])
                              .map((Boat boat) => InkWell(
                                    onLongPress: () async {
                                      BoatsModel? boatsModel =
                                          await BoatDetailsBottomSheet.show(
                                              context,
                                              initialBoat: boat,
                                              isBoatEdit: true,
                                              date: controller.selectedDate);
                                      if (boatsModel != null) {
                                        await FirebaseFirestore.instance
                                            .collection("dailyBoats")
                                            .doc(DateFormat("dd-MM-yyyy")
                                                .format(
                                                    controller.selectedDate))
                                            .set(boatsModel.toJson());
                                      }
                                    },
                                    onTap: () {
                                      controller.selectedBoat = boat;
                                      controller.update();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 150,
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (boat.id ==
                                                controller.selectedBoat?.id)
                                            ? AppColors.background.skyBlue
                                            : Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${boat.name} @ ${boat.time}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: FontSize.small,
                                            color: (boat.id ==
                                                        controller
                                                            .selectedBoat?.id &&
                                                    boat.time ==
                                                        controller
                                                            .selectedBoat?.time)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()),
                    );
                  }),
            SizedBox(height: 20),
            _buildTimeTable(),
            SizedBox(height: 20),
            _buildBookingsList(),
            SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  ///==================UI===================///

  Widget _buildBookingTypeSelector() {
    return GetBuilder<BookingsCalenderWidgetControllerNew>(
        builder: (controller) {
      if (showDetails)
        return Column(
          children: [
            Row(
              children: [
                _buildTabButton(
                  "Theory",
                  () {
                    controller.selectedType = FilterType.Theory;
                  },
                  count: controller.theoryCountA,
                  enable: controller.selectedType == FilterType.Theory,
                  color: Colors.orangeAccent,
                ),
                _buildTabButton(
                  "Pool",
                  () {
                    controller.selectedType = FilterType.Pool;
                  },
                  count: controller.poolCountA,
                  enable: controller.selectedType == FilterType.Pool,
                  color: Colors.green,
                ),
                _buildTabButton(
                  "Dive",
                  () {
                    controller.selectedType = FilterType.Dive;
                  },
                  count: controller.diveCountA,
                  enable: controller.selectedType == FilterType.Dive,
                  color: Colors.lightBlueAccent,
                ),
              ],
            ),
          ],
        );
      else
        return SizedBox();
    });
  }

  Widget _buildTabButton(
    String title,
    Function onTap, {
    bool enable = false,
    Color? color,
    int? count,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap as void Function()?,
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
                  child: FittedBox(
                    child: Center(
                      child: Text(
                        "$count",
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildTimeTable() {
    logic.getTime();
    return GetBuilder<BookingsCalenderWidgetControllerNew>(
        builder: (controller) {
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
                      _buildTitle("Bookings"),
                      SizedBox(width: 3),
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
                      .map((date) => _buildTimings(date))
                      .toList()),
            ),
            if (!controller.showLoading)
              Column(
                children: [
                  Center(
                    child: _buildErrorMessage(controller),
                  ),
                  // SizedBox(height: 10),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildErrorMessage(BookingsCalenderWidgetControllerNew controller) {
    if (controller.selectedType == FilterType.Theory &&
        controller.theoryCountA == 0)
      return Text(
        "No theory sessions found",
        style: TextStyle(fontSize: 15),
      );
    if (controller.selectedType == FilterType.Pool &&
        controller.poolCountA == 0)
      return Text(
        "No pool sessions found",
        style: TextStyle(fontSize: 15),
      );
    if (controller.selectedType == FilterType.Dive &&
        controller.diveCountA == 0)
      return Text(
        "No dive sessions found",
        style: TextStyle(fontSize: 15),
      );
    if (controller.theoryCountA == 0 &&
        controller.poolCountA == 0 &&
        controller.diveCountA == 0)
      return Text(
        "No bookings found",
        style: TextStyle(fontSize: 15),
      );
    return SizedBox();
  }

  List<DateTime> get filteredDates {
    return [];
  }

  Widget _buildBookingsList() {
    return GetBuilder<BookingsCalenderWidgetControllerNew>(
        builder: (controller) {
      if (!showDetails) return SizedBox();

      //print(controller.bookings);
      List<ItemModel> bookingExpansionList = [];
      if (controller.selectedType == null)
        bookingExpansionList = controller.expansionItemModels;
      else if (controller.selectedType == FilterType.Theory) {
        controller.expansionItemModels.forEach((element) {
          if (element.session.contains("Theory"))
            bookingExpansionList.add(element);
          var count = 0;
          bookingExpansionList.forEach((element) {
            count += element.pax!;
          });
          controller.theoryCountN = count;
          controller.theoryCount = bookingExpansionList.length;
        });
      } else if (controller.selectedType == FilterType.Pool) {
        controller.expansionItemModels.forEach((element) {
          if (element.session.contains("Pool"))
            bookingExpansionList.add(element);
          var count = 0;
          bookingExpansionList.forEach((element) {
            count += element.pax!;
          });
          controller.poolCountN = count;
          controller.poolCount = bookingExpansionList.length;
        });
      } else if (controller.selectedType == FilterType.Dive) {
        controller.expansionItemModels.forEach((element) {
          if (element.session.contains("Dive"))
            bookingExpansionList.add(element);
          var count = 0;
          bookingExpansionList.forEach((element) {
            count += element.pax!;
          });
          controller.diveCountN = count;
          controller.diveCount = bookingExpansionList.length;
        });
      }

      if (showDetails && isBookingScreen)
        return BookingsExpansionPanel(
          items: bookingExpansionList,
          onDeletePressed: () {},
          searchBar: true,
          onSearchTap: () {
            if (onSearchTap != null) onSearchTap!();
          },
        );
      else if (showDetails && !isBookingScreen) {
        List<ItemModel> boatDetailsExpansionList = [];
        if (controller.selectedBoat != null) {
          bookingExpansionList.forEach((itemModel) {
            bool isIdSame = itemModel.bookingModel
                    ?.getBoatInfo(controller.selectedDate)
                    ?.id ==
                (controller.selectedBoat?.id ?? "-");

            if (isIdSame) {
              boatDetailsExpansionList.add(itemModel);
            }
          });
        } else {
          boatDetailsExpansionList = bookingExpansionList;
        }

        return CustomersExpansionPanel(
          showSearchBar: true,
          items: boatDetailsExpansionList,
          onSearchTap: () {
            if (onSearchTap != null) {
              onSearchTap!();
            }
          },
          selectedDate: controller.selectedDate,
        );
      }
      return SizedBox();
    });
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
            fontFamily: AppFonts.nunito),
      ),
    );
  }

  Widget _buildTimings(DateTime date) {
    return GetBuilder<BookingsCalenderWidgetControllerNew>(
        builder: (controller) {
      getCircleColor(BookingsCalenderWidgetControllerNew controller) {
        if (controller.selectedDate == date)
          return AppColors.background.skyBlue;
        if (highlightInvalidTime &&
            DateTime.now().difference(date).inSeconds > 0)
          return AppColors.background.grey;
      }

      Widget? num = _getEventsCount(controller, date);

      if (num == null && showDetails) return SizedBox();
      return GestureDetector(
        onTap: () {
          if (highlightInvalidTime &&
              DateTime.now().difference(date).inSeconds > 0) {
            showToast("Invalid Date");
          } else {
            controller.selectedDate = date;
            //print("Selected Date : ${controller.selectedDate}");
            logic.filterBookingsList();
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

  Widget _buildDaySelector() {
    getDotColor(int index, BookingsCalenderWidgetControllerNew controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.green;
      return isSameDates(controller.calenderDates[index], DateTime.now())
          ? AppColors.background.skyBlue
          : AppColors.background.grey;
    }

    getDateColor(int index, BookingsCalenderWidgetControllerNew controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.white;
      return AppColors.background.black;
    }

    getDayColor(int index, BookingsCalenderWidgetControllerNew controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.white;
      return AppColors.background.black;
    }

    getBoxColor(int index, BookingsCalenderWidgetControllerNew controller) {
      if (isSameDates(controller.selectedDate, controller.calenderDates[index]))
        return Colors.black;
      return isSameDates(controller.calenderDates[index], DateTime.now())
          ? AppColors.background.datesBlue
          : AppColors.background.white;
    }

    return GetBuilder<BookingsCalenderWidgetControllerNew>(
        builder: (controller) {
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

  Widget? _getEventsCount(
    BookingsCalenderWidgetControllerNew controller,
    DateTime date,
  ) {
    var show = false;
    int totalBookings = 0;

    controller.bookings.forEach((booking) {
      var allBookingsList = [];

      if (controller.selectedType == null) {
        allBookingsList.addAll(booking.diveDate!);
        allBookingsList.addAll(booking.poolDate!);
        allBookingsList.addAll(booking.theoryDate!);
        allBookingsList.forEach((bookingDate) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        });
      } else if (controller.selectedType == FilterType.Theory) {
        allBookingsList.addAll(booking.theoryDate!);
        allBookingsList.forEach((bookingDate) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        });
      } else if (controller.selectedType == FilterType.Pool) {
        allBookingsList.addAll(booking.poolDate!);
        allBookingsList.forEach((bookingDate) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        });
      } else if (controller.selectedType == FilterType.Dive) {
        allBookingsList.addAll(booking.diveDate!);
        allBookingsList.forEach((bookingDate) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        });
      }
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
}

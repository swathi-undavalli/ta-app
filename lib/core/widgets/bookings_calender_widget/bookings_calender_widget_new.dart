import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../features/boat/models/boats.dart';
import '../../../features/boat/presentation/widgets/boat_details_bottom_sheet.dart';
import '../../../features/boat/presentation/widgets/customer_expansion_panel.dart';
import '../../constants/constants.dart';
import '../../constants/enums.dart';
import '../../models/item_model.dart';
import '../../util/utils.dart';
import '../access_levels.dart';
import '../booking_expansion_panel.dart';
import '../time_picker.dart';
import 'bookings_calender_widget_controller_new.dart';

// ignore: must_be_immutable
class BookingsCalenderWidgetNew extends StatelessWidget {
  DateTime? startDate;

  final void Function(DateTime) onDateTimeSelected;
  final bool isDiveSession;
  final bool showDetails;
  final Function? onSearchTap;
  final bool highlightInvalidTime;
  final bool isBookingScreen;
  final FilterType? calenderType;
  final AutoScrollController autoScrollController;

  BookingsCalenderWidgetNew({
    super.key,
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
    startDate ??= DateTime.now();
    startDate = startDate?.subtract(const Duration(days: 1));
    logic.controller.startDate = startDate;
    logic.controller.showDetails = showDetails;
    logic.controller.isDiveSession = isDiveSession;
    logic.controller.calenderType = calenderType;
    logic.getDates();
    if (showDetails) {
      EmployeeAccess.run(
          function: autoCenterDaySelector, access: AccessRights.viewBookings);
    } else {
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
    await Future.delayed(const Duration(microseconds: 500));
    scrollToIndex(50);
    logic.onDateSelected(DateTime.now());
  }

  Future<void> scrollToSelectedDate() async {
    await Future.delayed(const Duration(microseconds: 500));
    int index = startDate!.difference(logic.controller.selectedDate).inDays;
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
              if (showDetails) const SizedBox(height: 20),
              _buildBookingTypeSelector(),
              const SizedBox(height: 15),
              if (showDetails && !isBookingScreen)
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('dailyBoats')
                      .doc(DateFormat('dd-MM-yyyy')
                          .format(controller.selectedDate))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
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
                      return const Text(
                        'No boats are added yet',
                      );
                    }

                    BoatsModel? boatsModel =
                        BoatsModel.fromMap(data as Map<String, dynamic>);

                    if ((boatsModel.boats ?? []).isEmpty) {
                      return const Text(
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

                    return Wrap(
                      children: (boatsModel.boats ?? [])
                          .map(
                            (Boat boat) => InkWell(
                              onLongPress: () async {
                                BoatsModel? boatsModel =
                                    await BoatDetailsBottomSheet.show(
                                  context,
                                  initialBoat: boat,
                                  isBoatEdit: true,
                                  date: controller.selectedDate,
                                );
                                if (boatsModel != null) {
                                  await FirebaseFirestore.instance
                                      .collection('dailyBoats')
                                      .doc(DateFormat('dd-MM-yyyy')
                                          .format(controller.selectedDate))
                                      .set(boatsModel.toMap());
                                }
                              },
                              onTap: () {
                                controller.selectedBoat = boat;
                                controller.update();
                              },
                              child: Container(
                                height: 30,
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      (boat.id == controller.selectedBoat?.id)
                                          ? AppColors.background.skyBlue
                                          : Colors.white,
                                ),
                                child: Text(
                                  '${boat.name} @ ${boat.time}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSize.small,
                                    color: (boat.id ==
                                                controller.selectedBoat?.id &&
                                            boat.time ==
                                                controller.selectedBoat?.time)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ).paddingOnly(top: 4),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              const SizedBox(height: 20),
              _buildTimeTable(),
              const SizedBox(height: 20),
              _buildBookingsList(),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  ///==================UI===================///

  Widget _buildBookingTypeSelector() {
    return GetBuilder<BookingsCalenderWidgetControllerNew>(
      builder: (controller) {
        if (showDetails) {
          return Column(
            children: [
              Row(
                children: [
                  _buildTabButton(
                    'Theory',
                    () {
                      controller.selectedType = FilterType.Theory;
                    },
                    count: controller.theoryCountA,
                    enable: controller.selectedType == FilterType.Theory,
                    color: Colors.orangeAccent,
                  ),
                  _buildTabButton(
                    'Pool',
                    () {
                      controller.selectedType = FilterType.Pool;
                    },
                    count: controller.poolCountA,
                    enable: controller.selectedType == FilterType.Pool,
                    color: Colors.green,
                  ),
                  _buildTabButton(
                    'Dive',
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
        } else {
          return const SizedBox();
        }
      },
    );
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
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        '$count',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
          width: Screen.width,
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
                      .toList(),
                ),
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
      },
    );
  }

  Widget _buildErrorMessage(BookingsCalenderWidgetControllerNew controller) {
    if (controller.selectedType == FilterType.Theory &&
        controller.theoryCountA == 0) {
      return const Text(
        'No theory sessions found',
        style: TextStyle(fontSize: 15),
      );
    }
    if (controller.selectedType == FilterType.Pool &&
        controller.poolCountA == 0) {
      return const Text(
        'No pool sessions found',
        style: TextStyle(fontSize: 15),
      );
    }
    if (controller.selectedType == FilterType.Dive &&
        controller.diveCountA == 0) {
      return const Text(
        'No dive sessions found',
        style: TextStyle(fontSize: 15),
      );
    }
    if (controller.theoryCountA == 0 &&
        controller.poolCountA == 0 &&
        controller.diveCountA == 0) {
      return const Text(
        'No bookings found',
        style: TextStyle(fontSize: 15),
      );
    }
    return const SizedBox();
  }

  List<DateTime> get filteredDates {
    return [];
  }

  Widget _buildBookingsList() {
    return GetBuilder<BookingsCalenderWidgetControllerNew>(
      builder: (controller) {
        if (!showDetails) return const SizedBox();

        List<ItemModel> bookingExpansionList = [];
        if (controller.selectedType == null) {
          bookingExpansionList = controller.expansionItemModels;
        } else if (controller.selectedType == FilterType.Theory) {
          for (var element in controller.expansionItemModels) {
            if (element.session.contains('Theory'))
              bookingExpansionList.add(element);
            var count = 0;
            for (var element in bookingExpansionList) {
              count += element.pax!;
            }
            controller.theoryCountN = count;
            controller.theoryCount = bookingExpansionList.length;
          }
        } else if (controller.selectedType == FilterType.Pool) {
          for (var element in controller.expansionItemModels) {
            if (element.session.contains('Pool'))
              bookingExpansionList.add(element);
            var count = 0;
            for (var element in bookingExpansionList) {
              count += element.pax!;
            }
            controller.poolCountN = count;
            controller.poolCount = bookingExpansionList.length;
          }
        } else if (controller.selectedType == FilterType.Dive) {
          for (var element in controller.expansionItemModels) {
            if (element.session.contains('Dive'))
              bookingExpansionList.add(element);
            var count = 0;
            for (var element in bookingExpansionList) {
              count += element.pax!;
            }
            controller.diveCountN = count;
            controller.diveCount = bookingExpansionList.length;
          }
        }

        if (showDetails && isBookingScreen) {
          return BookingsExpansionPanel(
            items: bookingExpansionList,
            onDeletePressed: () {},
            searchBar: true,
            selectedDate: controller.selectedDate,
            onSearchTap: () {
              if (onSearchTap != null) onSearchTap!();
            },
          );
        } else if (showDetails && !isBookingScreen) {
          List<ItemModel> boatDetailsExpansionList = [];
          if (controller.selectedBoat != null) {
            for (var itemModel in bookingExpansionList) {
              bool isIdSame = itemModel.bookingModel
                      ?.getBoatInfo(controller.selectedDate)
                      ?.id ==
                  (controller.selectedBoat?.id ?? '-');

              if (isIdSame) {
                boatDetailsExpansionList.add(itemModel);
              }
            }
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
        return const SizedBox();
      },
    );
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
          fontFamily: AppFonts.nunito,
        ),
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

        if (num == null && showDetails) return const SizedBox();
        return GestureDetector(
          onTap: () {
            if (highlightInvalidTime &&
                DateTime.now().difference(date).inSeconds > 0) {
              showToast('Invalid Date');
            } else {
              controller.selectedDate = date;
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
                              ? DateFormat('hh').format(date)
                              : DateFormat('hh:mm').format(date),
                          style: TextStyle(
                              color: AppColors.text.black,
                              fontFamily: AppFonts.nunito,
                              fontSize: 10),
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
      },
    );
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
        return SizedBox(
          height: 100,
          width: Screen.width,
          child: ListView.builder(
            itemCount: 400,
            controller: autoScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              DateTime currentDate = controller.calenderDates[index];
              return AutoScrollTag(
                controller: autoScrollController,
                key: ValueKey(index),
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      //print("======Started");
                      // logic.controller.lastSelectedIndex = index;
                      logic.onDateSelected(currentDate);
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
                              DateFormat('MMM').format(currentDate),
                              style: TextStyle(
                                color: getDotColor(index, controller),
                                fontSize: FontSize.small,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              currentDate.day.toString(),
                              style: TextStyle(
                                color: getDateColor(index, controller),
                                fontSize: FontSize.textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('EE').format(currentDate),
                              style: TextStyle(
                                color: getDayColor(index, controller),
                                fontSize: FontSize.small,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget? _getEventsCount(
    BookingsCalenderWidgetControllerNew controller,
    DateTime date,
  ) {
    var show = false;
    int totalBookings = 0;

    for (var booking in controller.bookings) {
      var allBookingsList = [];

      if (controller.selectedType == null) {
        allBookingsList.addAll(booking.diveDate!);
        allBookingsList.addAll(booking.poolDate!);
        allBookingsList.addAll(booking.theoryDate!);
        for (var bookingDate in allBookingsList) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        }
      } else if (controller.selectedType == FilterType.Theory) {
        allBookingsList.addAll(booking.theoryDate!);
        for (var bookingDate in allBookingsList) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        }
      } else if (controller.selectedType == FilterType.Pool) {
        allBookingsList.addAll(booking.poolDate!);
        for (var bookingDate in allBookingsList) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        }
      } else if (controller.selectedType == FilterType.Dive) {
        allBookingsList.addAll(booking.diveDate!);
        for (var bookingDate in allBookingsList) {
          if (isSameMinute(date, bookingDate)) {
            totalBookings += booking.noOfPersons!;
            show = true;
          }
        }
      }
    }
    if (show) {
      return Container(
        height: 12,
        width: 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.background.skyBlue),
        ),
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

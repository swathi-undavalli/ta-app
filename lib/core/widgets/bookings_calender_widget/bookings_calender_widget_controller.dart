import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

import '../app-expansion-panel.dart';
import 'package:intl/intl.dart';

class BookingsCalenderWidgetLogic {
  BookingsCalenderWidgetController controller =
      Get.put(BookingsCalenderWidgetController());

  getBookings(DateTime date) async {
    log("getBookings");
    controller.bookingTimings = [];
    controller.bookings = [];
    controller.showLoading = true;
    try {
      var data = await FirebaseFirestore.instance
          .collection("bookings")
          .where("bookingDate",
              arrayContains:
                  "${date.day < 10 ? "0${date.day}" : date.day}-${date.month < 10 ? "0${date.month}" : date.month}-${date.year}")
          .get();

      // var data = await FirebaseFirestore.instance
      //     .collection("bookings")
      //     .get();
      // log("count=====${count.toString()}");
      data.docs.forEach((element) {
        log("===========s${element.data().toString()}");
        BookingModel booking = BookingModel.fromMap(element.data());
        if (booking.diveDate != null) {
          controller.bookingTimings.addAll(booking.diveDate);
        }
        if (booking.poolDate != null) {
          controller.bookingTimings.addAll(booking.poolDate);
        }
        if (booking.theoryDate != null) {
          controller.bookingTimings.addAll(booking.theoryDate);
        }

        controller.bookings.add(booking);

        List<ItemModel> newItemsList = [];
        controller.theoryCount = 0;
        controller.poolCount = 0;
        controller.diveCount = 0;
        controller.theoryCountN = 0;
        controller.poolCountN = 0;
        controller.diveCountN = 0;

        log("===================wb1");
        controller.bookings.forEach((booking) {
          var im = ItemModel.fromBookings(booking);
          im.session = "";
          im.time = "";

          // if (checkDate(booking.theoryDate[0], controller.selectedDate)) {
          //   controller.theoryCount++;
          //   im.session = im.session + "Theory, ";
          //   im.time = im.time +
          //       DateFormat("hh:mm ").format(booking.theoryDate[0]) +
          //       ", ";
          // }

          booking.theoryDate.forEach((date) {
            log("theory loop");
            if (checkDate(date, controller.selectedDate)) {
              controller.theoryCountN += booking.noOfPersons;
              controller.theoryCount++;
              im.session = im.session + "Theory, ";
              im.time = im.time + DateFormat("hh:mm ").format(date) + ", ";
            }
          });

          booking.poolDate.forEach((date) {
            log("pool loop");
            print("date $date");
            if (checkDate(date, controller.selectedDate)) {
              controller.poolCountN += booking.noOfPersons;
              controller.poolCount++;
              im.session = im.session + "Pool, ";
              im.time = im.time + DateFormat("hh:mm ").format(date) + ", ";
            }
          });

          booking.diveDate.forEach((date) {
            log("dive loop");
            if (checkDate(date, controller.selectedDate)) {
              controller.diveCount++;
              controller.diveCountN += booking.noOfPersons;
              im.session = im.session + "Dive, ";
              im.time = im.time + DateFormat("hh:mm ").format(date) + ", ";
            }
          });

          im.session = im.session.substring(0, im.session.length - 2);
          im.time = im.time.substring(0, im.time.length - 2);
          newItemsList.add(im);
        });
        controller.expansionItemModels = newItemsList;
      });
    } catch (e) {}

    controller.showLoading = false;
    controller.update();
  }

  filterBookingsList() {
    print('==============================');
    print("seleted Time : ${controller.selectedDate}");

    controller.bookings.forEach((element) {
      print(".........");
      print(element.activity[0].name);
      print(element.theoryDate);
      print(element.poolDate);
      print(element.diveDate);
      print(".........");
    });

    print("filtering started........\n\n");
    List<ItemModel> newItemsList = [];
    controller.poolCount = 0;
    controller.theoryCount = 0;
    controller.diveCount = 0;
    controller.bookings.forEach((booking) {
      var im = ItemModel.fromBookings(booking);

      if (booking.theoryDate != null && booking.theoryDate.isNotEmpty) {
        booking.theoryDate.forEach((date) {
          print("+++++++++++");
          print(date);
          print(controller.selectedDate);
          if (isSameMinute(date, controller.selectedDate)) {
            im.session = "Theory";
            im.time = DateFormat("hh:mm").format(date);
            print("im.time ${im.time}");
            controller.theoryCount++;
            controller.theoryCountN += booking.noOfPersons;
            newItemsList.add(im);
          }
        });
      }
      if (booking.poolDate != null && booking.poolDate.isNotEmpty) {
        booking.poolDate.forEach((date) {
          print("+++++++++++");
          print(date);
          print(controller.selectedDate);
          if (isSameMinute(date, controller.selectedDate)) {
            im.session = "Pool";
            im.time = DateFormat("hh:mm").format(date);
            print("im.time ${im.time}");
            controller.poolCount += booking.noOfPersons;
            newItemsList.add(im);
          }
        });
      }
      if (booking.diveDate != null && booking.diveDate.isNotEmpty) {
        booking.diveDate.forEach((date) {
          print("+++++++++++");
          print(date);
          print(controller.selectedDate);
          if (isSameMinute(date, controller.selectedDate)) {
            im.session = "Dive";
            im.time = DateFormat("hh:mm").format(date);
            print("im.time ${im.time}");
            controller.diveCount += booking.noOfPersons;
            newItemsList.add(im);
          }
        });
      }
    });
    print("filtering done........");

    newItemsList.forEach((element) {
      print(".........");
      print(element.activity);
      print(element.time);
      print(element.session);
      print(".........");
    });

    if (controller.theoryCount != 0)
      controller.selectedType = FilterType.Theory;
    else if (controller.poolCount != 0)
      controller.selectedType = FilterType.Pool;
    else if (controller.diveCount != 0)
      controller.selectedType = FilterType.Dive;

    controller.expansionItemModels = newItemsList;
    controller.update();

    print('==============================');
  }

  getDates() {
    log("getDates");
    controller.calenderDates = [];
    var temp = controller.startDate;
    for (int i = 0; i < 400; i++) {
      temp = temp.add(Duration(days: 1));
      controller.calenderDates.add(temp);
    }
  }

  getTime() {
    getLimit() {
      if (controller.isDiveSession && controller.showDetails)
        return 18 + 12;
      else if (controller.isDiveSession && controller.showDetails == false)
        return 18 + 2;
      else
        return 18;
    }

    controller.timeTable = [];
    var hour = 3;
    if (controller.calenderType == null)
      hour = controller.showDetails ? 3 : 5;
    else {
      if (controller.calenderType == FilterType.Theory)
        hour = 7;
      else if (controller.calenderType == FilterType.Pool)
        hour = 5;
      else if (controller.calenderType == FilterType.Dive) hour = 5;
    }
    var endHour = 23;
    if (controller.calenderType == null)
      endHour = 23;
    else {
      if (controller.calenderType == FilterType.Theory)
        endHour = 12 + 5;
      else if (controller.calenderType == FilterType.Pool)
        endHour = 12 + 6;
      else if (controller.calenderType == FilterType.Dive) endHour = 12 + 11;
    }
    var temp = DateTime(
      controller.selectedDate.year,
      controller.selectedDate.month,
      controller.selectedDate.day,
      hour - 1,
    );
    for (int i = 0; i < getLimit(); i++) {
      if (controller.isDiveSession)
        temp = temp.add(Duration(minutes: 30));
      else
        temp = temp.add(Duration(hours: 1));

      if (temp.hour != 0 && temp.hour < endHour + 1)
        controller.timeTable.add(temp);
    }
  }

  onDateSelected(int index) {
    // appExpansionPanelController.bookings = [];
    controller.lastDateIndex = index;
    controller.expansionItemModels = [];
    controller.poolCount = 0;
    controller.theoryCount = 0;
    controller.diveCount = 0;
    controller.poolCountN = 0;
    controller.theoryCountN = 0;
    controller.diveCountN = 0;
    controller.selectedDate = controller.calenderDates[index];
    controller.selectedType = null;
    print("===========started${controller.calenderDates[index]}");
    getBookings(controller.calenderDates[index]);
    print("===========ended${controller.calenderDates[index]}");
    getTime();
  }
}

class BookingsCalenderWidgetController extends GetxController {
  List<DateTime> bookingTimings = [];
  List<BookingModel> bookings = [];
  List<ItemModel> _expansionBookings = [];

  DateTime _startDate;
  bool _showLoading = false;

  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
  );
  DateTime _selectedTime;

  List<DateTime> calenderDates = [];
  List<DateTime> timeTable = [];

  FilterType _selectedType;

  int theoryCount = 0, poolCount = 0, diveCount = 0;
  int theoryCountN = 0, poolCountN = 0, diveCountN = 0;

  bool showDetails;

  int lastDateIndex;

  int lastSelectedIndex;

  bool isDiveSession;

  FilterType calenderType;

  // AutoScrollController autoScrollController = AutoScrollController();
  // AutoScrollController autoScrollController;

  get selectedDate => _selectedDate;

  bool get showLoading => _showLoading;

  DateTime get startDate => _startDate;

  DateTime get selectedTime => _selectedTime;

  List<ItemModel> get expansionItemModels => _expansionBookings;

  FilterType get selectedType => _selectedType;

  set selectedType(FilterType value) {
    _selectedType = value;
    update();
  }

  set expansionItemModels(List<ItemModel> value) {
    _expansionBookings = value;
    update();
  }

  set selectedTime(DateTime value) {
    _selectedTime = value;
    update();
  }

  set startDate(DateTime value) {
    _startDate = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set selectedDate(value) {
    _selectedDate = value;
    update();
  }
}

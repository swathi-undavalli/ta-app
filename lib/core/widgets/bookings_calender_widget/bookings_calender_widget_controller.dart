import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

import '../app-expansion-panel.dart';
import 'package:intl/intl.dart';

class BookingsCalenderWidgetLogic {
  BookingsCalenderWidgetController controller =
      Get.put(BookingsCalenderWidgetController());
  // AppExpansionPanelController appExpansionPanelController =
  //     Get.put(AppExpansionPanelController());

  // getBookings(DateTime date) async {
  //   print("getBookings");
  //   controller.bookingTimings = [];
  //   controller.bookings = [];
  //   controller.showLoading = true;
  //   var data = await FirebaseFirestore.instance
  //       .collection("bookings")
  //       .where("bookingDate",
  //           arrayContains:
  //               "${date.day < 10 ? "0${date.day}" : date.day}-${date.month < 10 ? "0${date.month}" : date.month}-${date.year}")
  //       .get();
  //   data.docs.forEach((element) {
  //     print(element.data());
  //     BookingModel booking = BookingModel.fromMap(element.data());
  //     if (booking.diveDate != null)
  //       controller.bookingTimings.add(booking.diveDate);
  //     if (booking.poolDate != null)
  //       controller.bookingTimings.add(booking.poolDate);
  //     if (booking.theoryDate != null)
  //       controller.bookingTimings.add(booking.theoryDate);
  //
  //     controller.bookings.add(booking);
  //
  //     List<ItemModel> newItemsList = [];
  //     controller.theoryCount = 0;
  //     controller.poolCount = 0;
  //     controller.diveCount = 0;
  //
  //     print("===================wb");
  //     controller.bookings.forEach((booking) {
  //       var im = ItemModel.fromBookings(booking);
  //       im.session = "";
  //       im.time = "";
  //       if (checkDate(booking.theoryDate, controller.selectedDate)) {
  //         controller.theoryCount++;
  //         im.session = im.session + "Theory, ";
  //         im.time =
  //             im.time + DateFormat("hh:mm").format(booking.theoryDate) + ", ";
  //       }
  //       if (checkDate(booking.poolDate, controller.selectedDate)) {
  //         controller.poolCount++;
  //         im.session = im.session + "Pool, ";
  //         im.time =
  //             im.time + DateFormat("hh:mm").format(booking.poolDate) + ", ";
  //       }
  //       if (checkDate(booking.diveDate, controller.selectedDate)) {
  //         controller.diveCount++;
  //         im.session = im.session + "Dive, ";
  //         im.time =
  //             im.time + DateFormat("hh:mm").format(booking.diveDate) + ", ";
  //       }
  //       im.session = im.session.substring(0, im.session.length - 2);
  //       im.time = im.time.substring(0, im.time.length - 2);
  //       newItemsList.add(im);
  //     });
  //
  //     var newList =
  //         controller.bookings.map((e) => ItemModel.fromBookings(e)).toList();
  //     //Ponny
  //     controller.expansionBookings = newItemsList;
  //   });
  //   controller.showLoading = false;
  //   controller.update();
  // }

  // filterBookingsList() {
  //   print('==============================');
  //   print("seleted Time : ${controller.selectedDate}");
  //   controller.bookings.forEach((element) {
  //     print(element.activity[0].name);
  //     print(element.theoryDate);
  //     print(element.poolDate);
  //     print(element.diveDate);
  //     print(".........");
  //   });
  //   print("filtering started........\n\n");
  //   List<ItemModel> newItemsList = [];
  //   controller.poolCount = 0;
  //   controller.theoryCount = 0;
  //   controller.diveCount = 0;
  //   controller.bookings.forEach((booking) {
  //     var im = ItemModel.fromBookings(booking);
  //     if ((booking.theoryDate.difference(controller.selectedDate).inDays ==
  //             0) &&
  //         (booking.theoryDate.hour == controller.selectedDate.hour)) {
  //       im.session = "Theory";
  //       im.time = DateFormat("hh:mm").format(booking.theoryDate);
  //       controller.theoryCount++;
  //       newItemsList.add(im);
  //     } else if ((booking.poolDate.difference(controller.selectedDate).inDays ==
  //             0) &&
  //         (booking.poolDate.hour == controller.selectedDate.hour)) {
  //       im.session = "Pool";
  //       im.time = DateFormat("hh:mm").format(booking.poolDate);
  //       controller.poolCount++;
  //       newItemsList.add(im);
  //     } else if ((booking.diveDate.difference(controller.selectedDate).inDays ==
  //             0) &&
  //         (booking.diveDate.hour == controller.selectedDate.hour)) {
  //       im.session = "Dive";
  //       im.time = DateFormat("hh:mm").format(booking.diveDate);
  //       controller.diveCount++;
  //       newItemsList.add(im);
  //     }
  //   });
  //   print("filtering done........");
  //
  //   newItemsList.forEach((element) {
  //     print(element.activity);
  //     print(element.time);
  //     print(element.session);
  //     print(".........");
  //   });
  //
  //   if (controller.theoryCount != 0)
  //     controller.selectedType = FilterType.Theory;
  //   else if (controller.poolCount != 0)
  //     controller.selectedType = FilterType.Pool;
  //   else if (controller.diveCount != 0)
  //     controller.selectedType = FilterType.Dive;
  //
  //   controller.expansionBookings = newItemsList;
  //   print(controller.expansionBookings);
  //   controller.update();
  //
  //   print('==============================');
  // }

  // AppExpansionPanelController appExpansionPanelController =
  //     Get.put(AppExpansionPanelController());

  getBookings(DateTime date) async {
    print("getBookings");
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
      data.docs.forEach((element) {
        print(element.data());
        BookingModel booking = BookingModel.fromMap(element.data());
        if (booking.diveDate != null)
          controller.bookingTimings.add(booking.diveDate);
        if (booking.poolDate != null)
          controller.bookingTimings.add(booking.poolDate);
        if (booking.theoryDate != null)
          controller.bookingTimings.add(booking.theoryDate);

        controller.bookings.add(booking);

        List<ItemModel> newItemsList = [];
        controller.theoryCount = 0;
        controller.poolCount = 0;
        controller.diveCount = 0;

        print("===================wb");
        controller.bookings.forEach((booking) {
          var im = ItemModel.fromBookings(booking);
          im.session = "";
          im.time = "";
          if (checkDate(booking.theoryDate, controller.selectedDate)) {
            controller.theoryCount++;
            im.session = im.session + "Theory, ";
            im.time = im.time +
                DateFormat("hh:mm ").format(booking.theoryDate) +
                ", ";
          }
          if (checkDate(booking.poolDate, controller.selectedDate)) {
            controller.poolCount++;
            im.session = im.session + "Pool, ";
            im.time =
                im.time + DateFormat("hh:mm").format(booking.poolDate) + ", ";
          }
          if (checkDate(booking.diveDate, controller.selectedDate)) {
            controller.diveCount++;
            im.session = im.session + "Dive, ";
            im.time =
                im.time + DateFormat("hh:mm").format(booking.diveDate) + ", ";
          }
          im.session = im.session.substring(0, im.session.length - 2);
          im.time = im.time.substring(0, im.time.length - 2);
          newItemsList.add(im);
        });

        var newList =
            controller.bookings.map((e) => ItemModel.fromBookings(e)).toList();
        //Ponny
        controller.expansionBookings = newItemsList;
      });
    } catch (e) {}

    controller.showLoading = false;
    controller.update();
  }

  filterBookingsList() {
    print('==============================');
    print("seleted Time : ${controller.selectedDate}");
    controller.bookings.forEach((element) {
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
      if (booking.theoryDate != null &&
          (booking.theoryDate.difference(controller.selectedDate).inDays ==
              0) &&
          (booking.theoryDate.hour == controller.selectedDate.hour)) {
        im.session = "Theory";
        im.time = DateFormat("hh:mm").format(booking.theoryDate);
        controller.theoryCount++;
        newItemsList.add(im);
      } else if (booking.poolDate != null &&
          (booking.poolDate.difference(controller.selectedDate).inDays == 0) &&
          (booking.poolDate.hour == controller.selectedDate.hour)) {
        im.session = "Pool";
        im.time = DateFormat("hh:mm").format(booking.poolDate);
        controller.poolCount++;
        newItemsList.add(im);
      } else if (booking.diveDate != null &&
          (booking.diveDate.difference(controller.selectedDate).inDays == 0) &&
          (booking.diveDate.hour == controller.selectedDate.hour)) {
        im.session = "Dive";
        im.time = DateFormat("hh:mm").format(booking.diveDate);
        controller.diveCount++;
        newItemsList.add(im);
      }
    });
    print("filtering done........");

    newItemsList.forEach((element) {
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

    controller.expansionBookings = newItemsList;
    controller.update();

    print('==============================');
  }

  getDates() {
    print("Hello mawa");
    controller.calenderDates = [];
    var temp = controller.startDate;
    for (int i = 0; i < 100; i++) {
      temp = temp.add(Duration(days: 1));
      controller.calenderDates.add(temp);
    }
  }

  getTime() {
    controller.timeTable = [];
    var temp = DateTime(
      controller.selectedDate.year,
      controller.selectedDate.month,
      controller.selectedDate.day,
      controller.showDetails ? 3 : 5,
    );
    for (int i = 0; i < 18; i++) {
      if (controller.isDiveSession)
        temp = temp.add(Duration(minutes: 30));
      else
        temp = temp.add(Duration(hours: 1));
      controller.timeTable.add(temp);
    }
  }

  onDateSelected(int index) {
    // appExpansionPanelController.bookings = [];
    controller.lastDateIndex = index;
    controller.expansionBookings = [];
    controller.poolCount = 0;
    controller.theoryCount = 0;
    controller.diveCount = 0;
    controller.selectedDate = controller.calenderDates[index];
    getBookings(controller.calenderDates[index]);
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

  bool showDetails;

  int lastDateIndex;

  bool isDiveSession;

  get selectedDate => _selectedDate;

  bool get showLoading => _showLoading;

  DateTime get startDate => _startDate;

  DateTime get selectedTime => _selectedTime;

  List<ItemModel> get expansionBookings => _expansionBookings;

  FilterType get selectedType => _selectedType;

  set selectedType(FilterType value) {
    _selectedType = value;
    update();
  }

  set expansionBookings(List<ItemModel> value) {
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

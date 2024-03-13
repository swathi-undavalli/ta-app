import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../features/boat/models/boats.dart';
import '../../../features/bookings/models/booking_model.dart';
import '../../constants/enums.dart';
import '../../models/item_model.dart';
import '../../util/utils.dart';

class BookingsCalenderWidgetLogicNew {
  BookingsCalenderWidgetControllerNew controller = Get.put(BookingsCalenderWidgetControllerNew());

  Future<void> getBookings(DateTime date) async {
    log("BookingsCalenderWidgetLogicNew : getBookings ${DateFormat("dd-MM-yyyy").format(date)}");
    controller.bookingTimings = [];
    controller.bookings = [];
    controller.showLoading = true;
    // try {
    var data = await FirebaseFirestore.instance
        .collection('bookings')
        .where(
          'bookingDate',
          arrayContains: DateFormat('dd-MM-yyyy').format(date),
        )
        .get();

    log(data.docs.toString());
    for (var element in data.docs) {
      Booking booking = Booking.fromMap(element.data());

      if (booking.diveDate != null) {
        controller.bookingTimings.addAll(booking.diveDate ?? []);
      }
      if (booking.poolDate != null) {
        controller.bookingTimings.addAll(booking.poolDate ?? []);
      }
      if (booking.theoryDate != null) {
        controller.bookingTimings.addAll(booking.theoryDate ?? []);
      }

      controller.bookings.add(booking);

      List<ItemModel> newItemsList = [];
      controller.theoryCount = 0;
      controller.poolCount = 0;
      controller.diveCount = 0;
      controller.theoryCountN = 0;
      controller.poolCountN = 0;
      controller.diveCountN = 0;
      controller.theoryCountA = 0;
      controller.poolCountA = 0;
      controller.diveCountA = 0;

      //log("===================wb1");
      for (var booking in controller.bookings) {
        var im = ItemModel.fromBooking(booking);
        im.session = '';
        im.time = '';

        for (var date in (booking.theoryDate ?? [])) {
          if (checkDate(date, controller.selectedDate)) {
            controller.theoryCountN += booking.noOfPersons!;
            controller.theoryCountA += booking.noOfPersons!;
            controller.theoryCount++;
            im.session = '${im.session}Theory, ';
            im.time = "${im.time}${DateFormat("hh:mm ").format(date!)}, ";
          }
        }

        for (var date in (booking.poolDate ?? [])) {
          if (checkDate(date, controller.selectedDate)) {
            controller.poolCountN += booking.noOfPersons!;
            controller.poolCountA += booking.noOfPersons!;
            controller.poolCount++;
            im.session = '${im.session}Pool, ';
            im.time = "${im.time}${DateFormat("hh:mm ").format(date!)}, ";
          }
        }

        for (var date in (booking.diveDate ?? [])) {
          if (checkDate(date, controller.selectedDate)) {
            controller.diveCount++;
            controller.diveCountN += booking.noOfPersons!;
            controller.diveCountA += booking.noOfPersons!;
            im.session = '${im.session}Dive, ';
            im.time = "${im.time}${DateFormat("hh:mm ").format(date!)}, ";
          }
        }

        im.session = im.session.substring(0, im.session.length - 2);
        im.time = im.time.substring(0, im.time.length - 2);
        newItemsList.add(im);
      }
      controller.expansionItemModels = newItemsList;
    }


    controller.showLoading = false;
    controller.update();
  }

  filterBookingsList() {
    List<ItemModel> newItemsList = [];

    controller.poolCount = 0;
    controller.theoryCount = 0;
    controller.diveCount = 0;

    for (var booking in controller.bookings) {
      var im = ItemModel.fromBooking(booking);

      if (booking.theoryDate != null && booking.theoryDate!.isNotEmpty) {
        for (var date in booking.theoryDate!) {
          if (isSameMinute(date!, controller.selectedDate)) {
            im.session = 'Theory';
            im.time = DateFormat('hh:mm').format(date);

            newItemsList.add(im);
          }
        }
      }
      if (booking.poolDate != null && booking.poolDate!.isNotEmpty) {
        for (var date in booking.poolDate!) {
          if (isSameMinute(date!, controller.selectedDate)) {
            im.session = 'Pool';
            im.time = DateFormat('hh:mm').format(date);
            newItemsList.add(im);
          }
        }
      }
      if (booking.diveDate != null && booking.diveDate!.isNotEmpty) {
        for (var date in booking.diveDate!) {
          if (isSameMinute(date!, controller.selectedDate)) {
            im.session = 'Dive';
            im.time = DateFormat('hh:mm').format(date);
            newItemsList.add(im);
          }
        }
      }
    }

    if (controller.selectedType == null) {
      if (controller.theoryCount != 0) {
        controller.selectedType = FilterType.Theory;
      } else if (controller.poolCount != 0) {
        controller.selectedType = FilterType.Pool;
      } else if (controller.diveCount != 0) {
        controller.selectedType = FilterType.Dive;
      }
    }

    controller.expansionItemModels = newItemsList;
    controller.update();
  }

  getDates() {
    controller.calenderDates = [];
    var temp = controller.startDate;
    for (int i = 0; i < 400; i++) {
      temp = temp!.add(const Duration(days: 1));
      controller.calenderDates.add(temp);
    }
  }

  getTime() {
    getLimit() {
      int base = 12 + 9;
      if (controller.isDiveSession && controller.showDetails!) {
        return base + 12;
      } else if (controller.isDiveSession && controller.showDetails == false) {
        return base + 2;
      } else {
        return base;
      }
    }

    controller.timeTable = [];
    var hour = 3;
    if (controller.calenderType == null) {
      hour = controller.showDetails! ? 3 : 5;
    } else {
      if (controller.calenderType == FilterType.Theory) {
        hour = 7;
      } else if (controller.calenderType == FilterType.Pool) {
        hour = 5;
      } else if (controller.calenderType == FilterType.Dive) {
        hour = 5;
      }
    }
    var endHour = 23;
    if (controller.calenderType == null) {
      endHour = 23;
    } else {
      if (controller.calenderType == FilterType.Theory) {
        endHour = 12 + 5;
      } else if (controller.calenderType == FilterType.Pool) {
        endHour = 12 + 9;
      } else if (controller.calenderType == FilterType.Dive) {
        endHour = 12 + 11;
      }
    }
    var temp = DateTime(
      controller.selectedDate.year,
      controller.selectedDate.month,
      controller.selectedDate.day,
      hour - 1,
    );
    for (int i = 0; i < getLimit(); i++) {
      if (controller.isDiveSession) {
        temp = temp.add(const Duration(minutes: 30));
      } else {
        temp = temp.add(const Duration(hours: 1));
      }

      if (temp.hour != 0 && temp.hour < endHour + 1) {
        controller.timeTable.add(temp);
      }
    }
  }

  onDateSelected(DateTime date) {
    // controller.lastDateIndex = index;
    controller.expansionItemModels = [];
    resetCounts();
    controller.selectedDate = date;
    controller.selectedType = null;
    controller.selectedBoat = null;
    getBookings(date);
    getTime();
  }

  void resetCounts() {
    controller.poolCount = 0;
    controller.theoryCount = 0;
    controller.diveCount = 0;
    controller.poolCountN = 0;
    controller.theoryCountN = 0;
    controller.diveCountN = 0;
    controller.poolCountA = 0;
    controller.theoryCountA = 0;
    controller.diveCountA = 0;
  }
}

class BookingsCalenderWidgetControllerNew extends GetxController {
  List<DateTime?> bookingTimings = [];
  List<Booking> bookings = [];
  List<ItemModel> expansionItemModels = [];

  DateTime? _startDate;
  Boat? selectedBoat;
  bool _showLoading = false;

  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
  );
  DateTime? _selectedTime;

  List<DateTime> calenderDates = [];
  List<DateTime> timeTable = [];

  FilterType? _selectedType;
  List<String> boats = [
    'Tucy',
    '007',
    'Batman',
    'Ranga',
    'Traveller',
    'Class Room',
  ];

  int theoryCount = 0, poolCount = 0, diveCount = 0;
  int theoryCountN = 0, poolCountN = 0, diveCountN = 0;
  int theoryCountA = 0, poolCountA = 0, diveCountA = 0;

  bool? showDetails;

  // late int lastDateIndex;

  // int? lastSelectedIndex;

  late bool isDiveSession;

  FilterType? calenderType;

  get selectedDate => _selectedDate;

  bool get showLoading => _showLoading;

  DateTime? get startDate => _startDate;

  DateTime? get selectedTime => _selectedTime;

  FilterType? get selectedType => _selectedType;

  set selectedType(FilterType? value) {
    _selectedType = value;
    update();
  }

  set selectedTime(DateTime? value) {
    _selectedTime = value;
    update();
  }

  set startDate(DateTime? value) {
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../features/activities/model/colors_data.dart';
import '../../features/bookings/models/booking_model.dart';
import '../models/item_model.dart';

void disposeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showToast(String msg) {
  Fluttertoast.showToast(msg: msg);
}

getStringDate(DateTime newDate) {
  return DateFormat('dd-MM-yyyy').format(newDate);
}

checkDate(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return ((a.day == b.day) && (a.month == b.month) && (a.year == b.year));
}

isSameHour(DateTime a, DateTime b) {
  return ((a.difference(b).inDays == 0) && checkDate(a, b) && a.hour == b.hour);
}

isSameMinute(DateTime a, DateTime b) {
  return ((a.difference(b).inDays == 0) &&
      checkDate(a, b) &&
      a.hour == b.hour &&
      a.minute == b.minute);
}

int getInt(String number) {
  try {
    return int.parse(number);
  } catch (e) {
    return 0;
  }
}

Color getBookingColor(ItemModel itemModel) {
  if (itemModel.bookingModel?.cancelBooking == true) {
    return Colors.red.shade200;
  } else {
    if (colorsData!.blue.contains(itemModel.activity)) {
      return const Color(0xffA9EBF8).withOpacity(0.3);
    } else if (colorsData!.purple.contains(itemModel.activity)) {
      return const Color(0xffDDB3FF);
    } else if (colorsData!.red.contains(itemModel.activity)) {
      return const Color(0xffF8FF96);
    } else if (colorsData!.green.contains(itemModel.activity)) {
      return const Color(0xff96F1BD);
    } else if (colorsData!.white.contains(itemModel.activity)) {
      return const Color(0xffE0E0E0);
    } else {
      return const Color(0xffE0E0E0);
    }
  }
}

Future<void> removeBoat({
  required Booking bookingModel,
  required DateTime selectedDate,
}) async {
  bookingModel.setBoatInfo(
    selectedDate,
    null,
  );

  await FirebaseFirestore.instance.collection('bookings').doc(bookingModel.id).set(
        bookingModel.toMap(),
      );
}

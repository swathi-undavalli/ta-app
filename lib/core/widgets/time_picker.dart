import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialTime,
  }) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );
    if (pickedTime == null) return null;
    final selectedDateTime = DateTime.now().copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
    return selectedDateTime;
  }

  ///  parses from 'hh:mm a' to DateTime object
  static DateTime? getDateTime(String? timeString) {
    if (timeString != null) {
      final formatter = DateFormat('hh:mm a');
      final dateTime = formatter.parse(timeString);
      return dateTime;
    }
    return null;
  }

  static String? getFormattedTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
}

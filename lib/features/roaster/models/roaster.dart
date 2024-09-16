import 'dart:convert';

import '../../boat/models/boat_details.dart';
import 'customer_feedback.dart';

class Roaster {
  final Instructor? instructor;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final CustomerFeedback? customerFeedback;

  Roaster({
    required this.instructor,
    required this.timeIn,
    required this.timeOut,
    required this.customerFeedback,
  });

  Roaster copyWith({
    Instructor? instructor,
    DateTime? timeIn,
    DateTime? timeOut,
    bool? knowsSwimming,
    bool? interestedOwc,
    String? remarks,
    CustomerFeedback? customerFeedback,
  }) =>
      Roaster(
        instructor: instructor ?? this.instructor,
        timeIn: timeIn ?? this.timeIn,
        timeOut: timeOut ?? this.timeOut,
        customerFeedback: customerFeedback ?? this.customerFeedback,
      );

  factory Roaster.fromRawJson(String str) => Roaster.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Roaster.fromJson(Map<String, dynamic> json) {
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    return Roaster(
      instructor: (json['instructor'] != null) ? Instructor.fromJson(json['instructor']) : null,
      timeIn: parseDateOrNull(json['time_in']),
      timeOut: parseDateOrNull(json['time_out']),
      customerFeedback:
          (json['customer_feedback'] != null) ? CustomerFeedback.fromJson(json['customer_feedback']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'instructor': instructor?.toJson(),
        'time_in': timeIn?.toIso8601String(),
        'time_out': timeOut?.toIso8601String(),
        'customer_feedback': customerFeedback?.toJson(),
      };
}

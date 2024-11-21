import 'dart:convert';

import '../../boat/models/boat_details.dart';
import 'customer_feedback.dart';

class Roaster {
  final Instructor? instructor;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final CustomerFeedback? customerFeedback;
  final bool? isDived;

  Roaster({
    required this.instructor,
    required this.timeIn,
    required this.timeOut,
    required this.customerFeedback,
    required this.isDived,
  });

  Roaster copyWith({
    Instructor? instructor,
    DateTime? timeIn,
    DateTime? timeOut,
    CustomerFeedback? customerFeedback,
    bool? isDived,
  }) =>
      Roaster(
        instructor: instructor ?? this.instructor,
        timeIn: timeIn ?? this.timeIn,
        timeOut: timeOut ?? this.timeOut,
        customerFeedback: customerFeedback ?? this.customerFeedback,
        isDived: isDived ?? this.isDived,
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
      timeIn: parseDateOrNull(json['timeIn']),
      timeOut: parseDateOrNull(json['timeOut']),
      customerFeedback: (json['customerFeedback'] != null) ? CustomerFeedback.fromJson(json['customerFeedback']) : null,
      isDived: json['isDived'],
    );
  }

  Map<String, dynamic> toJson() => {
        'instructor': instructor?.toJson(),
        'timeIn': timeIn?.toIso8601String(),
        'timeOut': timeOut?.toIso8601String(),
        'customerFeedback': customerFeedback?.toJson(),
        'isDived': isDived,
      };
}

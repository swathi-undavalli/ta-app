import 'dart:convert';

import '../../boat/models/boat_details.dart';
import 'customer_feedback.dart';

// TODO: Use code generator
class Roaster {
  final Instructor? instructor;
  final Instructor? staffInstructor;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final CustomerFeedback? customerFeedback;
  final bool? isDived;

  Roaster({
    required this.instructor,
    required this.staffInstructor,
    required this.timeIn,
    required this.timeOut,
    required this.customerFeedback,
    required this.isDived,
  });

  Roaster copyWith({
    Instructor? instructor,
    Instructor? staffInstructor,
    DateTime? timeIn,
    DateTime? timeOut,
    CustomerFeedback? customerFeedback,
    bool? isDived,
  }) =>
      Roaster(
        instructor: instructor ?? this.instructor,
        staffInstructor: staffInstructor ?? this.staffInstructor,
        timeIn: timeIn ?? this.timeIn,
        timeOut: timeOut ?? this.timeOut,
        customerFeedback: customerFeedback ?? this.customerFeedback,
        isDived: isDived ?? this.isDived,
      );

  factory Roaster.fromRawJson(String str) => Roaster.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory Roaster.fromMap(Map<String, dynamic> json) {
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    return Roaster(
      instructor: (json['instructor'] != null) ? Instructor.fromMap(json['instructor']) : null,
      staffInstructor: (json['staffInstructor'] != null) ? Instructor.fromMap(json['staffInstructor']) : null,
      timeIn: parseDateOrNull(json['timeIn']),
      timeOut: parseDateOrNull(json['timeOut']),
      customerFeedback: (json['customerFeedback'] != null) ? CustomerFeedback.fromMap(json['customerFeedback']) : null,
      isDived: json['isDived'],
    );
  }

  Map<String, dynamic> toMap() => {
        'instructor': instructor?.toMap(),
        'staffInstructor': staffInstructor?.toMap(),
        'timeIn': timeIn?.toIso8601String(),
        'timeOut': timeOut?.toIso8601String(),
        'customerFeedback': customerFeedback?.toMap(),
        'isDived': isDived,
      };
}

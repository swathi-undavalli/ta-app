import 'dart:convert';

import '../../boat/models/boat_details.dart';


class Roaster {
  final Instructor? instructor;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final bool? knowsSwimming;
  final bool? interestedOwc;
  final String? remarks;

  Roaster({
    required this.instructor,
    required this.timeIn,
    required this.timeOut,
    required this.knowsSwimming,
    required this.interestedOwc,
    required this.remarks,
  });

  Roaster copyWith({
    Instructor? instructor,
    DateTime? timeIn,
    DateTime? timeOut,
    bool? knowsSwimming,
    bool? interestedOwc,
    String? remarks,
  }) =>
      Roaster(
        instructor: instructor ?? this.instructor,
        timeIn: timeIn ?? this.timeIn,
        timeOut: timeOut ?? this.timeOut,
        knowsSwimming: knowsSwimming ?? this.knowsSwimming,
        interestedOwc: interestedOwc ?? this.interestedOwc,
        remarks: remarks ?? this.remarks,
      );

  factory Roaster.fromRawJson(String str) =>
      Roaster.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Roaster.fromJson(Map<String, dynamic> json) => Roaster(
        instructor: Instructor.fromMap(json['instructor']),
        timeIn: DateTime.parse(json['time_in']),
        timeOut: DateTime.parse(json['time_out']),
        knowsSwimming: json['knows_swimming'],
        interestedOwc: json['interested_owc'],
        remarks: json['remarks'],
      );

  Map<String, dynamic> toJson() => {
        'instructor': instructor?.toJson(),
        'time_in': timeIn?.toIso8601String(),
        'time_out': timeOut?.toIso8601String(),
        'knows_swimming': knowsSwimming,
        'interested_owc': interestedOwc,
        'remarks': remarks,
      };
}

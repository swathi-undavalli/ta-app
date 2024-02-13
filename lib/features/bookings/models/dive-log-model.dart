import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../boat/models/boat_details.dart';

class DiveLogModel {
  final Timestamp date;
  final Timestamp time;
  final Instructor instructor;
  final String course;
  final String diveSite;
  final String tankNo;
  final String bottomTime;
  final String maxDepth;
  final String bookingId;

  DiveLogModel({
    required this.date,
    required this.time,
    required this.instructor,
    required this.course,
    required this.diveSite,
    required this.tankNo,
    required this.bottomTime,
    required this.maxDepth,
    required this.bookingId,
  });

  DiveLogModel copyWith({
    Timestamp? date,
    Timestamp? time,
    Instructor? instructor,
    String? course,
    String? diveSite,
    String? tankNo,
    String? bottomTime,
    String? maxDepth,
    String? bookingId,
  }) =>
      DiveLogModel(
        date: date ?? this.date,
        time: time ?? this.time,
        instructor: instructor ?? this.instructor,
        course: course ?? this.course,
        diveSite: diveSite ?? this.diveSite,
        tankNo: tankNo ?? this.tankNo,
        bottomTime: bottomTime ?? this.bottomTime,
        maxDepth: maxDepth ?? this.maxDepth,
        bookingId: bookingId ?? this.bookingId,
      );

  factory DiveLogModel.fromRawJson(String str) => DiveLogModel.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory DiveLogModel.fromMap(Map<String, dynamic>? json) => DiveLogModel(
        date: json?['date'],
        time: json?['time'],
        instructor: Instructor.fromMap(json?['instructor']),
        course: json?['course'],
        diveSite: json?['diveSite'],
        tankNo: json?['tankNo'],
        bottomTime: json?['bottomTime'],
        maxDepth: json?['maxDepth'],
        bookingId: json?['bookingId'],
      );

  Map<String, dynamic> toMap() => {
        'date': date,
        'time': time,
        'instructor': instructor.toJson(),
        'course': course,
        'diveSite': diveSite,
        'tankNo': tankNo,
        'bottomTime': bottomTime,
        'maxDepth': maxDepth,
        'bookingId': bookingId,
      };
}

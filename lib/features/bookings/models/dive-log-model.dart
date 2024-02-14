import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../boat/models/boat_details.dart';

class DiveLogModel {
  final Timestamp date;
  final Timestamp time;
  final Instructor instructor;
  final String course;
  final String diveSite;
  final int tankNo;
  final int bottomTime;
  final double maxDepth;
  final String bookingId;
  final String id;

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
    required this.id,
  });

  DiveLogModel copyWith({
    Timestamp? date,
    Timestamp? time,
    Instructor? instructor,
    String? course,
    String? diveSite,
    int? tankNo,
    int? bottomTime,
    double? maxDepth,
    String? bookingId,
    String? id,
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
        id: id ?? this.id,
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
        id: json?['id'],
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
        'id': id,
      };
}

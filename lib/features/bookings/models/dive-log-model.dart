import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../boat/models/boat_details.dart';

class DiveLogModel {
  final Timestamp timeIn;
  final Instructor instructor;
  final String course;
  final String diveSite;
  final int tankNo;
  final int bottomTime;
  final double maxDepth;
  final String bookingId;
  final String id;
  final String? rentalEquipment;

  DiveLogModel({
    required this.timeIn,
    required this.instructor,
    required this.course,
    required this.diveSite,
    required this.tankNo,
    required this.bottomTime,
    required this.maxDepth,
    required this.bookingId,
    required this.id,
    required this.rentalEquipment,
  });

  DiveLogModel copyWith({
    Timestamp? timeIn,
    Instructor? instructor,
    String? course,
    String? diveSite,
    int? tankNo,
    int? bottomTime,
    double? maxDepth,
    String? bookingId,
    String? id,
    String? rentalEquipment,
  }) =>
      DiveLogModel(
        timeIn: timeIn ?? this.timeIn,
        instructor: instructor ?? this.instructor,
        course: course ?? this.course,
        diveSite: diveSite ?? this.diveSite,
        tankNo: tankNo ?? this.tankNo,
        bottomTime: bottomTime ?? this.bottomTime,
        maxDepth: maxDepth ?? this.maxDepth,
        bookingId: bookingId ?? this.bookingId,
        id: id ?? this.id,
        rentalEquipment: rentalEquipment ?? this.rentalEquipment,
      );

  factory DiveLogModel.fromRawJson(String str) => DiveLogModel.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory DiveLogModel.fromMap(Map<String, dynamic>? map) => DiveLogModel(
        timeIn: map?['timeIn'],
        instructor: Instructor.fromMap(map?['instructor']),
        course: map?['course'],
        diveSite: map?['diveSite'],
        tankNo: map?['tankNo'],
        bottomTime: map?['bottomTime'],
        maxDepth: map?['maxDepth'],
        bookingId: map?['bookingId'],
        id: map?['id'],
        rentalEquipment: map?['rentalEquipment'],
      );

  Map<String, dynamic> toMap() => {
        'timeIn': timeIn,
        'instructor': instructor.toMiniJson(),
        'course': course,
        'diveSite': diveSite,
        'tankNo': tankNo,
        'bottomTime': bottomTime,
        'maxDepth': maxDepth,
        'bookingId': bookingId,
        'id': id,
        'rentalEquipment': rentalEquipment,
      };
}

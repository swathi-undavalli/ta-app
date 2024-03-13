import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../boat/models/boat_details.dart';

class Event {
  final String session;
  final String id;
  final List<Instructor> employees;
  final String location;
  final DateTime dateTime;
  final String phone;
  final String? createdBy;

  Event({
    required this.session,
    required this.id,
    required this.employees,
    required this.location,
    required this.dateTime,
    required this.phone,
    required this.createdBy,
  });

  Event copyWith({
    String? session,
    String? id,
    List<Instructor>? employees,
    String? location,
    DateTime? dateTime,
    String? phone,
    String? createdBy,
  }) =>
      Event(
        session: session ?? this.session,
        id: id ?? this.id,
        employees: employees ?? this.employees,
        location: location ?? this.location,
        dateTime: dateTime ?? this.dateTime,
        phone: phone ?? this.phone,
        createdBy: createdBy ?? this.createdBy,
      );

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        session: json['session'],
        id: json['id'],
        employees: List<Instructor>.from(
            (json['employees']).map((x) => Instructor.fromMap(x))),
        location: json['location'],
        dateTime: (json['dateTime'] as Timestamp).toDate(),
        phone: json['phone'],
        createdBy: json['createdBy'],
      );

  Map<String, dynamic> toJson() => {
        'session': session,
        'id': id,
        'employees': List<dynamic>.from((employees).map((x) => x.toJson())),
        'location': location,
        'dateTime': Timestamp.fromDate(dateTime),
        'phone': phone,
        'createdBy': createdBy,
      };
}

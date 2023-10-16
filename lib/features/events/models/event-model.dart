import 'dart:convert';

import 'package:temple_adventures/features/boat/models/boat-details.dart';

class Event {
  final List<EventElement>? eventElement;

  Event({
    required this.eventElement,
  });

  Event copyWith({
    List<EventElement>? event,
  }) =>
      Event(
        eventElement: event ?? this.eventElement,
      );

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventElement: List<EventElement>.from((json["event"] ?? ([])).map((x) => EventElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "event": List<dynamic>.from((eventElement ?? []).map((x) => x.toJson())),
      };
}

class EventElement {
  final String session;
  final List<Instructor> employees;
  final String location;
  final String time;
  final String date;
  final String phone;
  final String? createdBy;

  EventElement({
    required this.session,
    required this.employees,
    required this.location,
    required this.time,
    required this.date,
    required this.phone,
    required this.createdBy,
  });

  EventElement copyWith({
    String? session,
    List<Instructor>? employees,
    String? location,
    String? time,
    String? date,
    String? phone,
    String? createdBy,
  }) =>
      EventElement(
        session: session ?? this.session,
        employees: employees ?? this.employees,
        location: location ?? this.location,
        time: time ?? this.time,
        date: date ?? this.date,
        phone: phone ?? this.phone,
        createdBy: createdBy ?? this.createdBy,
      );

  factory EventElement.fromRawJson(String str) => EventElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventElement.fromJson(Map<String, dynamic> json) => EventElement(
        session: json["session"],
        employees: List<Instructor>.from((json["employees"]).map((x) => Instructor.fromJson(x))),
        location: json["location"],
        time: json["time"],
        date: json["date"],
        phone: json["phone"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "session": session,
        "employees": List<dynamic>.from((employees).map((x) => x.toJson())),
        "location": location,
        "time": time,
        "date": date,
        "phone": phone,
        "createdBy": createdBy,
      };
}

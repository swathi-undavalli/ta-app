import 'dart:convert';

import '../../employees/model/employee.dart';

class BoatDetails {
  int? bookingStatus;
  final String? employeeNotes;
  final List<Instructor>? instructors;
  final List<Instructor>? diveBuddies;
  Map<String, dynamic>? boat;
  Map<String, dynamic>? status;

  BoatDetails({
    this.bookingStatus,
    this.status,
    this.boat,
    this.employeeNotes,
    this.instructors,
    this.diveBuddies,
  });

  BoatDetails copyWith({
    Map<String, dynamic>? boatId,
    Map<String, dynamic>? status,
    String? employeeNotes,
    int? bookingStatus,
    List<Instructor>? instructors,
    List<Instructor>? diveBuddies,
  }) =>
      BoatDetails(
        boat: boatId ?? boat,
        status: status ?? this.status,
        employeeNotes: employeeNotes ?? this.employeeNotes,
        bookingStatus: bookingStatus ?? this.bookingStatus,
        instructors: instructors ?? this.instructors,
        diveBuddies: diveBuddies ?? this.diveBuddies,
      );

  factory BoatDetails.fromRawJson(String str, List<String>? bookingDate) =>
      BoatDetails.fromMap(json.decode(str), bookingDate);

  String toRawJson() => json.encode(toMap());

  factory BoatDetails.fromMap(Map<String, dynamic>? json, List<String?>? bookingDate) {
    if (json == null) return BoatDetails();

    List<Instructor>? instructors;

    if (((json['instructors'] as List?) ?? []).length == 1) {
      Instructor ins = Instructor.fromMap(json['instructors'][0]);

      if (((json['instructorTanks'] ?? {}) as Map).isNotEmpty) {
        (json['instructorTanks'] as Map<String, dynamic>).forEach((date, tankInfo) {
          instructors ??= [];
          var i = ins.copyWith(
            date: date,
            air: tankInfo['air'] ?? 0,
            nitrox: tankInfo['nitrox'] ?? 0,
          );

          instructors?.add(i);
        });
      }

      // instructorTanks and date in the instructor model is null
      else if (((json['instructorTanks'] ?? {}) as Map).isEmpty && ins.date == null) {
        for (var date in (bookingDate ?? [])) {
          instructors ??= [];
          var i = ins.copyWith(
            date: date,
            air: ins.air ?? 0,
            nitrox: ins.nitrox ?? 0,
          );

          instructors.add(i);
        }
      }
    }

    return BoatDetails(
      boat: json['boat'] ?? {},
      status: json['status'] ?? {},
      employeeNotes: json['employeeNotes'],
      bookingStatus: json['bookingStatus'],
      instructors: instructors ??
          List<Instructor>.from(
            (json['instructors'] ?? []).map((x) => Instructor.fromMap(x)),
          ),
      diveBuddies: List<Instructor>.from(
        (json['diveBuddies'] ?? []).map((x) => Instructor.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'boat': boat,
        'bookingStatus': bookingStatus,
        'employeeNotes': employeeNotes,
        'status': status,
        'instructors': List<dynamic>.from((instructors ?? []).map((x) => x.toMap())),
        'diveBuddies': List<dynamic>.from((diveBuddies ?? []).map((x) => x.toMap())),
      };
}

class Instructor {
  final String id;
  final String name;
  String? date;
  int? air;
  int? nitrox;
  String? phone;
  String? gender;

  Instructor({
    required this.id,
    required this.name,
    this.date,
    this.air,
    this.nitrox,
    this.gender,
    this.phone,
  });

  Instructor copyWith({
    String? id,
    String? name,
    int? air,
    int? nitrox,
    String? phone,
    String? date,
  }) =>
      Instructor(
        id: id ?? this.id,
        name: name ?? this.name,
        air: air ?? this.air,
        nitrox: nitrox ?? this.nitrox,
        phone: phone ?? this.phone,
        date: date ?? this.date,
      );

  factory Instructor.fromRawJson(String str) => Instructor.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory Instructor.fromMap(Map<String, dynamic> json) => Instructor(
        id: json['id'],
        name: json['name'],
        air: json['air'],
        nitrox: json['nitrox'],
        phone: json['phone'],
        date: json['date'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'nitrox': nitrox,
        'air': air,
        'date': date,
      };

  Map<String, dynamic> toMiniJson() => {
        'id': id,
        'name': name,
      };

  factory Instructor.fromEmployee(Employee employee) {
    return Instructor(
      id: employee.id,
      name: employee.name,
      air: null,
      nitrox: null,
      phone: employee.phoneNumber,
      gender: employee.gender,
    );
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) {
    if ((other is Employee || other is Instructor)) {
      if (other is Instructor) {
        return id == other.id && date == other.date;
      }
      if (other is Employee) {
        return id == other.id;
      }
    }
    return false;
  }
}

class BoatInfo {
  final String id;
  final int air;
  final int nitrox;

  BoatInfo({
    required this.id,
    required this.air,
    required this.nitrox,
  });

  BoatInfo copyWith({
    String? id,
    int? air,
    int? nitrox,
  }) =>
      BoatInfo(
        id: id ?? this.id,
        air: air ?? this.air,
        nitrox: nitrox ?? this.nitrox,
      );

  factory BoatInfo.fromJson(String str) => BoatInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BoatInfo.fromMap(Map<String, dynamic> json) => BoatInfo(
        id: json['id'],
        air: json['air'],
        nitrox: json['nitrox'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'air': air,
        'nitrox': nitrox,
      };
}

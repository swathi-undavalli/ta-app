import 'dart:convert';

import 'package:temple_adventures/features/employees/model/employee.dart';

class BoatDetails {
  int? bookingStatus;
  List<Intern>? interns;
  final String? employeeNotes;
  final List<Instructor>? instructors;
  Map<String, dynamic>? boat;
  Map<String, dynamic>? instructorTanks;
  Map<String, dynamic>? status;

  BoatDetails({
    this.bookingStatus,
    this.interns,
    this.status,
    this.boat,
    this.instructorTanks,
    this.employeeNotes,
    this.instructors,
  });

  BoatDetails copyWith({
    Map<String, dynamic>? boatId,
    Map<String, dynamic>? instructorTank,
    Map<String, dynamic>? status,
    String? employeeNotes,
    List<Intern>? interns,
    int? bookingStatus,
    List<Instructor>? instructors,
  }) =>
      BoatDetails(
        boat: boatId ?? this.boat,
        status: status ?? this.status,
        instructorTanks: instructorTank ?? this.instructorTanks,
        interns: interns ?? this.interns,
        employeeNotes: employeeNotes ?? this.employeeNotes,
        bookingStatus: bookingStatus ?? this.bookingStatus,
        instructors: instructors ?? this.instructors,
      );

  factory BoatDetails.fromRawJson(String str) =>
      BoatDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory BoatDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BoatDetails();
    return BoatDetails(
      boat: json["boat"] ?? {},
      instructorTanks: json["instructorTanks"] ?? {},
      status: json["status"] ?? {},
      employeeNotes: json["employeeNotes"],
      bookingStatus: json["bookingStatus"],
      instructors: List<Instructor>.from(
          (json["instructors"] ?? []).map((x) => Instructor.fromJson(x))),
      interns: List<Intern>.from(
          (json["interns"] ?? []).map((x) => Intern.fromJson(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "boat": boat,
        "instructorTanks": instructorTanks,
        "bookingStatus": bookingStatus,
        "employeeNotes": employeeNotes,
        "status": status,
        "instructors":
            List<dynamic>.from((instructors ?? []).map((x) => x.toJson())),
        "interns": List<dynamic>.from((interns ?? []).map((x) => x.toJson())),
      };
}

class Instructor {
  final String id;
  final String name;
  int? air;
  int? nitrox;

  Instructor({
    required this.id,
    required this.name,
    required this.air,
    required this.nitrox,
  });

  Instructor copyWith({
    String? id,
    String? name,
    int? air,
    int? nitrox,
  }) =>
      Instructor(
        id: id ?? this.id,
        name: name ?? this.name,
        air: this.air,
        nitrox: this.nitrox,
      );

  factory Instructor.fromRawJson(String str) =>
      Instructor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        id: json["id"],
        name: json["name"],
        air: json["air"],
        nitrox: json["nitrox"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nitrox": nitrox,
        "air": air,
      };

  factory Instructor.fromEmployee(Employee employee) {
    return Instructor(
      id: employee.id,
      name: employee.name,
      air: null,
      nitrox: null,
    );
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) {
    if ((other is Employee || other is Instructor)) {
      if (other is Instructor) {
        return id == other.id;
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
        id: json["id"],
        air: json["air"],
        nitrox: json["nitrox"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "air": air,
        "nitrox": nitrox,
      };
}

class InstructorTanks {
  final int air;
  final int nitrox;

  InstructorTanks({
    required this.air,
    required this.nitrox,
  });

  InstructorTanks copyWith({
    int? air,
    int? nitrox,
  }) =>
      InstructorTanks(
        air: air ?? this.air,
        nitrox: nitrox ?? this.nitrox,
      );

  factory InstructorTanks.fromJson(String str) =>
      InstructorTanks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InstructorTanks.fromMap(Map<String, dynamic> json) => InstructorTanks(
        air: json["air"],
        nitrox: json["nitrox"],
      );

  Map<String, dynamic> toMap() => {
        "air": air,
        "nitrox": nitrox,
      };
}

class Intern {
  final String name;
  final int air;
  final int nitrox;

  Intern({
    required this.name,
    required this.air,
    required this.nitrox,
  });

  Intern copyWith({
    String? name,
    int? air,
    int? nitrox,
  }) =>
      Intern(
        name: name ?? this.name,
        air: air ?? this.air,
        nitrox: nitrox ?? this.nitrox,
      );

  factory Intern.fromRawJson(String str) => Intern.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Intern.fromJson(Map<String, dynamic> json) => Intern(
        name: json["name"],
        air: json["air"],
        nitrox: json["nitrox"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "air": air,
        "nitrox": nitrox,
      };
}

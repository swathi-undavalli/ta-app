import 'dart:convert';
import 'package:temple_adventures/features/home/model/employee.dart';

class BoatDetails {
  int? bookingStatus;
  final String? employeeNotes;
  final List<Instructor>? instructors;
  Map<String, dynamic>? boat;

  BoatDetails({
    this.bookingStatus,
    this.boat,
    this.employeeNotes,
    this.instructors,
  });

  BoatDetails copyWith({
    Map<String, dynamic>? boatId,
    String? employeeNotes,
    int? bookingStatus,
    List<Instructor>? instructors,
  }) =>
      BoatDetails(
        boat: boatId ?? this.boat,
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
      employeeNotes: json["employeeNotes"],
      bookingStatus: json["bookingStatus"],
      instructors: List<Instructor>.from(
          (json["instructors"] ?? []).map((x) => Instructor.fromJson(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "boat": boat,
        "bookingStatus": bookingStatus,
        "employeeNotes": employeeNotes,
        "instructors":
            List<dynamic>.from((instructors ?? []).map((x) => x.toJson())),
      };
}

class Instructor {
  final String id;
  final String name;

  Instructor({
    required this.id,
    required this.name,
  });

  Instructor copyWith({
    String? id,
    String? name,
  }) =>
      Instructor(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Instructor.fromRawJson(String str) =>
      Instructor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Instructor.fromJson(Map<String, dynamic> json) =>
      Instructor(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
      };

  factory Instructor.fromEmployee(Employee employee) {
    return Instructor(id: employee.id, name: employee.name);
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


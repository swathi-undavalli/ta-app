import 'dart:convert';
import 'package:temple_adventures/features/home/model/employee.dart';

class BoatDetails {
  final String? boatId;
  final String? boatName;
  final String? employeeNotes;
  final List<Instructor>? instructors;

  BoatDetails({
    this.boatId,
    this.boatName,
    this.employeeNotes,
    this.instructors,
  });

  BoatDetails copyWith({
    String? boatId,
    String? boatName,
    String? employeeNotes,
    List<Instructor>? instructors,
  }) =>
      BoatDetails(
        boatId: boatId ?? this.boatId,
        boatName: boatName ?? this.boatName,
        employeeNotes: employeeNotes ?? this.employeeNotes,
        instructors: instructors ?? this.instructors,
      );

  factory BoatDetails.fromRawJson(String str) =>
      BoatDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory BoatDetails.fromJson(Map<String, dynamic> json) {
    return BoatDetails(
      boatId: json["boatId"],
      boatName: json["boatName"],
      employeeNotes: json["employeeNotes"],
      instructors: List<Instructor>.from(
          (json["instructors"] ?? []).map((x) => Instructor.fromJson(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "boatId": boatId,
        "boatName": boatName,
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

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
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

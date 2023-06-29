import 'dart:convert';

import 'boat-details.dart';

class BoatsModel {
  final List<Boat>? boats;

  BoatsModel({
    required this.boats,
  });

  BoatsModel copyWith({
    List<Boat>? boats,
  }) =>
      BoatsModel(
        boats: boats ?? this.boats,
      );

  factory BoatsModel.fromRawJson(String str) =>
      BoatsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BoatsModel.fromJson(Map<String, dynamic>? json) => BoatsModel(
        boats: List<Boat>.from(
            (json?["boats"] ?? ([])).map((x) => Boat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "boats": List<dynamic>.from((boats ?? []).map((x) => x.toJson())),
      };
}

class Boat {
  final List<Instructor>? captains;
  final String id;
  final String? surfaceSupport;
  final String? notes;
  final int? nitroxInt;
  final int? airInt;
  final String name;

  Boat({
    required this.captains,
    required this.id,
    required this.nitroxInt,
    required this.airInt,
    required this.surfaceSupport,
    required this.notes,
    required this.name,
  });

  Boat copyWith({
    List<Instructor>? captains,
    String? id,
    int? nitroxInt,
    int? airInt,
    String? notes,
    String? surfaceSupport,
    String? name,
  }) =>
      Boat(
        captains: captains ?? this.captains,
        id: id ?? this.id,
        airInt: airInt ?? this.airInt,
        nitroxInt: nitroxInt ?? this.nitroxInt,
        surfaceSupport: surfaceSupport ?? this.surfaceSupport,
        notes: notes ?? this.notes,
        name: name ?? this.name,
      );

  factory Boat.fromRawJson(String str) => Boat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Boat.fromJson(Map<String, dynamic> json) => Boat(
        captains: List<Instructor>.from(
            (json["captains"] ?? []).map((x) => Instructor.fromJson(x))),
        id: json["id"],
        notes: json["notes"],
        nitroxInt: json["nitroxInt"],
        airInt: json["airInt"],
        surfaceSupport: json["surfaceSupport"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "captains": List<dynamic>.from((captains ?? []).map((x) => x.toJson())),
        "id": id,
        "surfaceSupport": surfaceSupport,
        "notes": notes,
        "airInt": airInt,
        "nitroxInt": nitroxInt,
        "name": name,
      };
}

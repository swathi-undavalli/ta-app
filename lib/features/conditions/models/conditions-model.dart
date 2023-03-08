// To parse this JSON data, do
//
//     final conditions = conditionsFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Conditions {
  Conditions({
    required this.id,
    required this.levels,
  });

  final String id;
  final List<Level> levels;

  Conditions copyWith({
    String? id,
    List<Level>? levels,
  }) =>
      Conditions(
        id: id ?? this.id,
        levels: levels ?? this.levels,
      );

  factory Conditions.fromJson(String str) => Conditions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Conditions.fromMap(Map<String, dynamic> json) => Conditions(
    id: json["id"],
    levels: List<Level>.from(json["levels"].map((x) => Level.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "levels": List<dynamic>.from(levels.map((x) => x.toMap())),
  };
}

class Level {
  Level({
    required this.depth,
    required this.fish,
    required this.visibility,
    required this.currents,
    required this.updatedAt,
  });

  final int depth;
  final int fish;
  final int visibility;
  final int currents;
  final DateTime updatedAt;

  Level copyWith({
    int? depth,
    int? fish,
    int? visibility,
    int? currents,
    DateTime? updatedAt,
  }) =>
      Level(
        depth: depth ?? this.depth,
        fish: fish ?? this.fish,
        visibility: visibility ?? this.visibility,
        currents: currents ?? this.currents,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Level.fromJson(String str) => Level.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Level.fromMap(Map<String, dynamic> json) => Level(
    depth: json["depth"],
    fish: json["fish"],
    visibility: json["visibility"],
    currents: json["currents"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "depth": depth,
    "fish": fish,
    "visibility": visibility,
    "currents": currents,
    "updatedAt": updatedAt.toIso8601String(),
  };
}

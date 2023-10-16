// To parse this JSON data, do
//
//     final conditions = conditionsFromMap(jsonString);

import 'dart:convert';

class Conditions {
  Conditions({
    required this.id,
    required this.surfaceConditions,
    required this.levels,
  });

  final String id;
  final List<SurfaceCondition> surfaceConditions;
  final List<Level> levels;

  Conditions copyWith({
    String? id,
    List<SurfaceCondition>? surfaceConditions,
    List<Level>? levels,
  }) =>
      Conditions(
        id: id ?? this.id,
        surfaceConditions: surfaceConditions ?? this.surfaceConditions,
        levels: levels ?? this.levels,
      );

  factory Conditions.fromJson(String str) =>
      Conditions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Conditions.fromMap(Map<String, dynamic> json) => Conditions(
        id: json['id'],
        surfaceConditions: List<SurfaceCondition>.from(
          json['surfaceConditions'].map((x) => SurfaceCondition.fromMap(x)),
        ),
        levels: List<Level>.from(json['levels'].map((x) => Level.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'surfaceConditions': List<dynamic>.from(surfaceConditions.map((x) => x.toMap())),
        'levels': List<dynamic>.from(levels.map((x) => x.toMap())),
      };
}

class Level {
  Level({
    required this.depth,
    required this.fish,
    required this.visibility,
    required this.currents,
    required this.updatedAt,
    required this.updatedBy,
    required this.reef,
  });

  final int depth;
  final int fish;
  final int visibility;
  final int currents;
  final DateTime updatedAt;
  final String reef;
  final String updatedBy;

  Level copyWith({
    int? depth,
    int? fish,
    int? visibility,
    int? currents,
    DateTime? updatedAt,
    String? reef,
    String? updatedBy,
  }) =>
      Level(
        depth: depth ?? this.depth,
        fish: fish ?? this.fish,
        visibility: visibility ?? this.visibility,
        currents: currents ?? this.currents,
        updatedAt: updatedAt ?? this.updatedAt,
        reef: reef ?? this.reef,
        updatedBy: updatedBy ?? this.updatedBy,
      );

  factory Level.fromJson(String str) => Level.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Level.fromMap(Map<String, dynamic> json) => Level(
        depth: json['depth'],
        fish: json['fish'],
        visibility: json['visibility'],
        currents: json['currents'],
        updatedAt: DateTime.parse(json['updatedAt']),
        reef: json['reef'],
        updatedBy: json['updatedBy'],
      );

  Map<String, dynamic> toMap() => {
        'depth': depth,
        'fish': fish,
        'visibility': visibility,
        'currents': currents,
        'updatedAt': updatedAt.toIso8601String(),
        'reef': reef,
        'updatedBy': updatedBy,
      };
}

class SurfaceCondition {
  SurfaceCondition({
    required this.reefName,
    required this.temp,
    required this.speed,
    required this.currents,
    required this.swell,
    required this.updatedAt,
    required this.updatedBy,
  });

  final String reefName;
  final double temp;
  final double speed;
  final double currents;
  final double swell;
  final String updatedBy;
  final DateTime updatedAt;

  SurfaceCondition copyWith({
    String? reefName,
    String? updatedBy,
    double? temp = 20,
    double? speed = 0,
    double? currents = 0,
    double? swell = 0,
    DateTime? updatedAt,
  }) =>
      SurfaceCondition(
        reefName: reefName ?? this.reefName,
        updatedBy: updatedBy ?? this.updatedBy,
        temp: temp ?? this.temp,
        speed: speed ?? this.speed,
        currents: currents ?? this.currents,
        swell: swell ?? this.swell,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SurfaceCondition.fromJson(String str) =>
      SurfaceCondition.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SurfaceCondition.fromMap(Map<String, dynamic> json) => SurfaceCondition(
        reefName: json['reefName'],
        updatedBy: json['updatedBy'],
        temp: json['temp']?.toDouble(),
        speed: json['speed']?.toDouble(),
        currents: json['currents']?.toDouble(),
        swell: json['swell']?.toDouble(),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toMap() => {
        'reefName': reefName,
        'updatedBy': updatedBy,
        'temp': temp,
        'speed': speed,
        'currents': currents,
        'swell': swell,
        'updatedAt': updatedAt.toIso8601String(),
      };
}

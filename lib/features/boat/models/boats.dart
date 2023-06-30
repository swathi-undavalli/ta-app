import 'dart:convert';

import 'package:temple_adventures/features/boat/models/boat-details.dart';

class BoatsModel {
  final List<Boat>? boats;
  final Dsd dsd;

  BoatsModel({
    required this.boats,
    required this.dsd,
  });

  BoatsModel copyWith({
    List<Boat>? boats,
    Dsd? dsd,
  }) =>
      BoatsModel(
        boats: boats ?? this.boats,
        dsd: dsd ?? this.dsd,
      );

  factory BoatsModel.fromRawJson(String str) => BoatsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BoatsModel.fromJson(Map<String, dynamic>? json) => BoatsModel(
        boats: List<Boat>.from((json?["boats"] ?? ([])).map((x) => Boat.fromJson(x))),
        dsd: Dsd.fromJson(json?["dsd"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "boats": List<dynamic>.from((boats ?? []).map((x) => x.toJson())),
        "dsd": dsd.toJson(),
      };
}

class Dsd {
  final String? bcd;
  final String? boots;
  final String? fins;
  final String? mask;
  final String? powerMask;
  final String? reg;
  final String? weight;

  final String? dayOff;
  final String? leaves;
  final String? generalNotes;
  final String? highTides;
  final String? lowTides;
  final String? waves;
  final String? winds;

  Dsd({
    required this.bcd,
    required this.boots,
    required this.fins,
    required this.mask,
    required this.powerMask,
    required this.reg,
    required this.weight,
    required this.dayOff,
    required this.leaves,
    required this.generalNotes,
    required this.highTides,
    required this.lowTides,
    required this.waves,
    required this.winds,
  });

  Dsd copyWith({
    String? bcd,
    String? boots,
    String? fins,
    String? mask,
    String? powerMask,
    String? reg,
    String? weight,
    String? dayOff,
    String? leaves,
    String? generalNotes,
    String? highTides,
    String? lowTides,
    String? waves,
    String? winds,
  }) =>
      Dsd(
        bcd: bcd ?? this.bcd,
        boots: boots ?? this.boots,
        fins: fins ?? this.fins,
        mask: mask ?? this.mask,
        powerMask: powerMask ?? this.powerMask,
        reg: reg ?? this.reg,
        weight: weight ?? this.weight,
        dayOff: dayOff ?? this.dayOff,
        leaves: leaves ?? this.leaves,
        generalNotes: generalNotes ?? this.generalNotes,
        highTides: highTides ?? this.highTides,
        lowTides: lowTides ?? this.lowTides,
        waves: waves ?? this.waves,
        winds: winds ?? this.winds,
      );

  factory Dsd.fromRawJson(String str) => Dsd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dsd.fromJson(Map<String, dynamic> json) => Dsd(
        bcd: json["bcd"],
        boots: json["boots"],
        fins: json["fins"],
        mask: json["mask"],
        powerMask: json["powerMask"],
        reg: json["reg"],
        weight: json["weight"],
        dayOff: json["dayOff"],
        leaves: json["leaves"],
        generalNotes: json["generalNotes"],
        highTides: json["highTides"],
        lowTides: json["lowTides"],
        waves: json["waves"],
        winds: json["winds"],
      );

  Map<String, dynamic> toJson() => {
        "bcd": bcd,
        "boots": boots,
        "fins": fins,
        "mask": mask,
        "powerMask": powerMask,
        "reg": reg,
        "weight": weight,
        "dayOff": dayOff,
        "leaves": leaves,
        "generalNotes": generalNotes,
        "highTides": highTides,
        "lowTides": lowTides,
        "waves": waves,
        "winds": winds,
      };
}

class Boat {
  final List<Instructor>? captains;
  final String id;
  final String time;
  final String? surfaceSupport;
  final String? notes;

  final int? nitrox;
  final int? air;
  final String name;
  final String? diveSite;

  Boat({
    required this.captains,
    required this.time,
    required this.id,
    required this.nitrox,
    required this.air,
    required this.surfaceSupport,
    required this.notes,
    required this.name,
    required this.diveSite,
  });

  Boat copyWith({
    List<Instructor>? captains,
    String? id,
    String? time,
    int? nitrox,
    int? airInt,
    String? notes,
    String? surfaceSupport,
    String? name,
    String? diveSite,
  }) =>
      Boat(
        captains: captains ?? this.captains,
        id: id ?? this.id,
        time: time ?? this.time,
        air: airInt ?? this.air,
        nitrox: nitrox ?? this.nitrox,
        surfaceSupport: surfaceSupport ?? this.surfaceSupport,
        notes: notes ?? this.notes,
        name: name ?? this.name,
        diveSite: diveSite ?? this.diveSite,
      );

  factory Boat.fromRawJson(String str) => Boat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Boat.fromJson(Map<String, dynamic> json) => Boat(
        captains: List<Instructor>.from((json["captains"] ?? []).map((x) => Instructor.fromJson(x))),
        id: json["id"],
        time: json["time"],
        notes: json["notes"],
        nitrox: json["nitrox"],
        air: json["air"],
        surfaceSupport: json["surfaceSupport"],
        diveSite: json["diveSite"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "captains": List<dynamic>.from((captains ?? []).map((x) => x.toJson())),
        "id": id,
        "time": time,
        "surfaceSupport": surfaceSupport,
        "notes": notes,
        "air": air,
        "diveSite": diveSite,
        "nitrox": nitrox,
        "name": name,
      };
}

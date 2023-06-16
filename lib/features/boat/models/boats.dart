import 'dart:convert';

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
  final String captainId;
  final String captainName;
  final String id;
  final String name;

  Boat({
    required this.captainId,
    required this.captainName,
    required this.id,
    required this.name,
  });

  Boat copyWith({
    String? captainId,
    String? captainName,
    String? id,
    String? name,
  }) =>
      Boat(
        captainId: captainId ?? this.captainId,
        captainName: captainName ?? this.captainName,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Boat.fromRawJson(String str) => Boat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Boat.fromJson(Map<String, dynamic> json) => Boat(
        captainId: json["captainId"],
        captainName: json["captainName"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "captainId": captainId,
        "captainName": captainName,
        "id": id,
        "name": name,
      };
}

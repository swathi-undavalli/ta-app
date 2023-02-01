import 'dart:convert';

class AttendancePersistenceModel {
  AttendancePersistenceModel({
    this.showCheckIn,
    this.showCheckOut,
    this.lastUpdated,
  });

  bool? showCheckIn;
  bool? showCheckOut;
  DateTime? lastUpdated;

  factory AttendancePersistenceModel.fromJson(String str) =>
      AttendancePersistenceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendancePersistenceModel.fromMap(Map<String, dynamic> json) =>
      AttendancePersistenceModel(
        showCheckIn: json["showCheckIn"],
        showCheckOut: json["showCheckOut"],
        lastUpdated: DateTime.parse(json["lastUpdated"]),
      );

  Map<String, dynamic> toMap() => {
        "showCheckIn": showCheckIn,
        "showCheckOut": showCheckOut,
        "lastUpdated": lastUpdated!.toIso8601String(),
      };
}

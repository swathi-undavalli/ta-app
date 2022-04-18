import 'dart:convert';

BoatsModel boatsModelFromMap(String str) => BoatsModel.fromMap(json.decode(str));

String boatsModelToMap(BoatsModel data) => json.encode(data.toMap());

class BoatsModel {
  BoatsModel({
    this.id,
    this.boatName,
    this.captainName,
    this.phoneNumber,
    this.capacity,
  });

  String id;
  String boatName;
  String captainName;
  String phoneNumber;
  int capacity;

  factory BoatsModel.fromMap(Map<String, dynamic> json) => BoatsModel(
    id: json["id"],
    boatName: json["boatName"],
    captainName: json["captainName"],
    phoneNumber: json["phoneNumber"],
    capacity: json["capacity"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "boatName": boatName,
    "captainName": captainName,
    "phoneNumber": phoneNumber,
    "capacity": capacity,
  };
}

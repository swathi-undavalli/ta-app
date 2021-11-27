import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeMiniModel {
  EmployeeMiniModel({
    this.shiftTime,
    this.phone,
    this.name,
    this.difference,
    this.loginTime,
    this.id,
    this.punctual,
  });

  String shiftTime;
  int difference;
  String phone;
  String name;
  Timestamp loginTime;
  String id;
  String punctual;

  factory EmployeeMiniModel.fromMap(Map<String, dynamic> json) =>
      EmployeeMiniModel(
        shiftTime: json["shiftTime"],
        phone: json["phone"],
        name: json["name"],
        loginTime: json["loginTime"],
        id: json["id"],
        difference: json["difference"],
        punctual: json["punctual"],
      );

  Map<String, dynamic> toMap() => {
        "shiftTime": shiftTime,
        "phone": phone,
        "name": name,
        "loginTime": loginTime,
        "id": id,
        "difference": difference,
        "punctual": punctual,
      };
}

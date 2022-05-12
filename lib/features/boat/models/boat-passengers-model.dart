// To parse this JSON data, do
//
//     final boatPassengersModel = boatPassengersModelFromMap(jsonString);

import 'dart:convert';

BoatPassengersModel boatPassengersModelFromMap(String str) =>
    BoatPassengersModel.fromMap(json.decode(str));

String boatPassengersModelToMap(BoatPassengersModel data) =>
    json.encode(data.toMap());

class BoatPassengersModel {
  BoatPassengersModel({
    this.passenger,
    this.employees,
  });

  List<Passenger> passenger;
  List<Employee> employees;

  factory BoatPassengersModel.fromMap(Map<String, dynamic> json) =>
      BoatPassengersModel(
        passenger: List<Passenger>.from(
            json["passenger"].map((x) => Passenger.fromMap(x))),
        employees: List<Employee>.from(
            json["employees"].map((x) => Employee.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "passenger": List<dynamic>.from(passenger.map((x) => x.toMap())),
        "employees": List<dynamic>.from(employees.map((x) => x.toMap())),
      };
}

class Employee {
  Employee({
    this.name,
    this.id,
    this.gender,
    this.phone,
    this.boatID,
  });

  String name;
  String boatID;
  String id;
  String gender;
  String phone;

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        name: json["name"],
        id: json["id"],
        gender: json["gender"],
        phone: json["phone"],
        boatID: json["boatID"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
        "gender": gender,
        "phone": phone,
        "boatID": boatID,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Employee && other.id == id && other.boatID == boatID;
  }

  @override
  int get hashCode {
    return id.hashCode ^ boatID.hashCode;
  }
}

class Passenger {
  Passenger({
    this.name,
    this.gender,
    this.phone,
    this.email,
    this.boatID,
  });

  String name;
  String gender;
  String phone;
  String email;
  String boatID;

  factory Passenger.fromMap(Map<String, dynamic> json) => Passenger(
        name: json["name"],
        gender: json["gender"],
        phone: json["phone"],
        email: json["email"],
        boatID: json["boatID"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "gender": gender,
        "phone": phone,
        "email": email,
        "boatID": boatID,
      };
}

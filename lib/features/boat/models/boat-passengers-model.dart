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
    this.passengers,
    this.employees,
  });

  List<Passenger> passengers;
  List<Employee> employees;

  factory BoatPassengersModel.fromMap(Map<String, dynamic> json) =>
      BoatPassengersModel(
        passengers: List<Passenger>.from(
            json["passengers"] ?? [].map((x) => Passenger.fromMap(x))),
        employees: List<Employee>.from(
            json["employees"] ?? [].map((x) => Employee.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "passengers": List<dynamic>.from(passengers.map((x) => x.toMap())),
        "employees": List<dynamic>.from(employees.map((x) => x.toMap())),
      };
}

class Passenger {
  Passenger({
    this.email,
    this.name,
    this.gender,
    this.phone,
  });

  String email;
  String name;
  String gender;
  String phone;

  factory Passenger.fromMap(Map<String, dynamic> json) => Passenger(
        email: json["email"],
        name: json["name"],
        gender: json["gender"],
        phone: json["phone"],
      );
  Map<String, dynamic> toMap() => {
        "email": email,
        "name": name,
        "gender": gender,
        "phone": phone,
      };
}

class Employee {
  Employee({
    this.id,
    this.name,
    this.gender,
    this.phone,
  });

  String id;
  String name;
  String gender;
  String phone;

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        phone: json["phone"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "gender": gender,
        "phone": phone,
      };
}

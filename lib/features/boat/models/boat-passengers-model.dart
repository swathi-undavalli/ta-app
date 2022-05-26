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
    this.freelancer,
  });

  List<Passenger> passenger;
  List<Employees> employees;
  List<Freelancer> freelancer;

  factory BoatPassengersModel.fromMap(Map<String, dynamic> json) =>
      BoatPassengersModel(
        passenger: List<Passenger>.from(
            json["passenger"].map((x) => Passenger.fromMap(x))),
        employees: List<Employees>.from(
            json["employees"].map((x) => Employees.fromMap(x))),
        freelancer: List<Freelancer>.from(
            json["freelancer"].map((x) => Freelancer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "passenger": List<dynamic>.from(passenger.map((x) => x.toMap())),
        "employees": List<dynamic>.from(employees.map((x) => x.toMap())),
        "freelancer": List<dynamic>.from(freelancer.map((x) => x.toMap())),
      };
}

class Employees {
  Employees({
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

  factory Employees.fromMap(Map<String, dynamic> json) => Employees(
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

    return other is Employees && other.id == id && other.boatID == boatID;
  }

  @override
  int get hashCode {
    return id.hashCode ^ boatID.hashCode;
  }
}

class Freelancer {
  Freelancer({
    this.name,
    this.gender,
    this.phone,
    this.boatID,
    this.id,

  });

  String name;
  String boatID;
  String gender;
  String phone;
  String id;

  factory Freelancer.fromMap(Map<String, dynamic> json) => Freelancer(
        name: json["name"],
        gender: json["gender"],
        phone: json["phone"],
        boatID: json["boatID"],
    id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "gender": gender,
        "phone": phone,
        "boatID": boatID,
        "id": id,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Freelancer &&
        other.phone == phone &&
        other.boatID == boatID;
  }

  @override
  int get hashCode {
    return phone.hashCode ^ boatID.hashCode;
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

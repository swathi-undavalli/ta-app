import 'dart:convert';

BoatPassengersModel boatPassengersModelFromMap(String str) =>
    BoatPassengersModel.fromMap(json.decode(str));

String boatPassengersModelToMap(BoatPassengersModel data) =>
    json.encode(data.toMap());

class BoatPassengersModel {
  BoatPassengersModel({
    this.passengers,
  });

  List<String> passengers;

  factory BoatPassengersModel.fromMap(Map<String, dynamic> json) =>
      BoatPassengersModel(
        passengers: List<String>.from(json["passengers"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "passengers": List<dynamic>.from(passengers.map((x) => x)),
      };
}

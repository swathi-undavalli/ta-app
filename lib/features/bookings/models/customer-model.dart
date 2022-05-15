import 'dart:convert';

CustomerModel customerModelFromMap(String str) => CustomerModel.fromMap(json.decode(str));

String customerModelToMap(CustomerModel data) => json.encode(data.toMap());

class CustomerModel {
  CustomerModel({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.countryCode,
    this.dob,
    this.email,
    this.gender,
    this.location,
    this.name,
    this.idProof,
    this.phoneNumber,
    this.pinCode,
    this.state,
  });

  String addressLine1;
  String addressLine2;
  String city;
  String country;
  String countryCode;
  String dob;
  String email;
  String gender;
  String location;
  String name;
  String idProof;
  String phoneNumber;
  String pinCode;
  String state;

  factory CustomerModel.fromMap(Map<String, dynamic> json) => CustomerModel(
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    city: json["city"],
    country: json["country"],
    countryCode: json["countryCode"],
    dob: json["dob"],
    email: json["email"],
    gender: json["gender"],
    location: json["location"],
    name: json["name"],
    idProof: json["idProof"],
    phoneNumber: json["phoneNumber"],
    pinCode: json["pinCode"],
    state: json["state"],
  );

  Map<String, dynamic> toMap() => {
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "city": city,
    "country": country,
    "countryCode": countryCode,
    "dob": dob,
    "email": email,
    "gender": gender,
    "location": location,
    "name": name,
    "idProof": idProof,
    "phoneNumber": phoneNumber,
    "pinCode": pinCode,
    "state": state,
  };
}

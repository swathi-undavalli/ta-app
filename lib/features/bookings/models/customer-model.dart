// To parse this JSON data, do
//
//     final customerModel = customerModelFromMap(jsonString);

import 'dart:convert';

CustomerModel customerModelFromMap(String str) =>
    CustomerModel.fromMap(json.decode(str));

String customerModelToMap(CustomerModel data) => json.encode(data.toMap());

class CustomerModel {
  CustomerModel({
    this.email,
    this.fistName,
    this.middleName,
    this.lastName,
    this.dob,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.city,
    this.pinCode,
    this.countryCode,
    this.phoneNumber,
    this.idProof,
    this.gender,
  });

  String email;
  String fistName;
  String middleName;
  String lastName;
  String dob;
  String addressLine1;
  String addressLine2;
  String country;
  String state;
  String city;
  String pinCode;
  String countryCode;
  String phoneNumber;
  String idProof;
  String gender;

  factory CustomerModel.fromMap(Map<String, dynamic> json) => CustomerModel(
        email: json["email"],
        fistName: json["fistName"],
        middleName: json["middleName"],
    idProof: json["idProof"],
        lastName: json["lastName"],
        dob: json["dob"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        pinCode: json["pinCode"],
        countryCode: json["countryCode"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "fistName": fistName,
        "middleName": middleName,
        "lastName": lastName,
        "dob": dob,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "idProof": idProof,
        "country": country,
        "state": state,
        "city": city,
        "pinCode": pinCode,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "gender": gender,
      };
}


/*class CustomerModel {
  CustomerModel({
    this.email,
    this.fistName,
    this.middleName,
    this.lastName,
    this.dob,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.city,
    this.pinCode,
    this.countryCode,
    this.phoneNumber,
    this.idProof,
    this.gender,
  });

  String email;
  String fistName;
  String middleName;
  String lastName;
  String dob;
  String addressLine1;
  String addressLine2;
  String country;
  String state;
  String city;
  String pinCode;
  String countryCode;
  String phoneNumber;
  String idProof;
  String gender;

  factory CustomerModel.fromMap(Map<String, dynamic> json) => CustomerModel(
        email: json["email"],
        fistName: json["fistName"],
        middleName: json["middleName"],
    idProof: json["idProof"],
        lastName: json["lastName"],
        dob: json["dob"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        pinCode: json["pinCode"],
        countryCode: json["countryCode"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "fistName": fistName,
        "middleName": middleName,
        "lastName": lastName,
        "dob": dob,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "idProof": idProof,
        "country": country,
        "state": state,
        "city": city,
        "pinCode": pinCode,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "gender": gender,
      };
}*/

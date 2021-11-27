import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:temple_adventures/features/attendance/attendance-model.dart';
import 'package:intl/intl.dart';

Employee currentEmployee;

enum AttendanceType {
  CheckIn,
  CheckOut,
}

class Employee {
  Employee({
    this.id,
    this.gender,
    this.phoneNumber,
    this.countryCode,
    this.role,
    this.accessLevels,
    this.shiftTiming,
    this.firstName,
    this.lastName,
    this.countryIsoCode,
  });

  String id;
  String gender;
  String phoneNumber;
  String countryCode;
  String role;
  AccessLevels accessLevels;
  DateTime shiftTiming;
  String firstName;
  String lastName;
  String countryIsoCode;

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
    id: json["id"],
    gender: json["gender"],
    phoneNumber: json["phoneNumber"],
    countryCode: json["countryCode"],
    countryIsoCode: json["countryIsoCode"],
    role: json["role"],
    accessLevels: AccessLevels.fromMap(json["accessLevels"]),
    shiftTiming: DateTime(
      2021,
      1,
      1,
      int.parse(json["shiftTiming"].split(":")[0]),
      int.parse(json["shiftTiming"].split(":")[0]),
      int.parse(json["shiftTiming"].split(":")[0]),
    ),
    firstName: json["firstName"],
    lastName: json["lastName"],
  );

  get name => firstName + " " + lastName;
  get authPhone => countryCode + phoneNumber;

  Map<String, dynamic> toMap() => {
    "id": id,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "countryCode": countryCode,
    "countryIsoCode": countryIsoCode,
    "role": role,
    "accessLevels": accessLevels.toMap(),
    "shiftTiming":
    "${shiftTiming.hour}:${shiftTiming.minute}:${shiftTiming.second}",
    "firstName": firstName,
    "lastName": lastName,
  };
}

class AccessLevels {
  AccessLevels({
    this.attendence,
    this.booking,
  });

  bool attendence;
  bool booking;

  factory AccessLevels.fromMap(Map<String, dynamic> json) => AccessLevels(
    attendence: json["attendence"],
    booking: json["booking"],
  );

  Map<String, dynamic> toMap() => {
    "attendence": attendence,
    "booking": booking,
  };
}
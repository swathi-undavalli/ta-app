import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  Attendance({
    this.checkInTime,
    this.checkInLocation,
    this.checkOutTime,
    this.checkOutLocation,
    this.LogTime,
    this.checkOutInput,
    this.checkInInput,
    this.punctual,
  });

  Timestamp checkInTime;
  String checkInLocation;
  Timestamp checkOutTime;
  String checkOutLocation;
  Timestamp LogTime;
  String checkOutInput;
  String checkInInput;
  String punctual;

  factory Attendance.fromMap(Map<String, dynamic> json) {
    print(json);
    return Attendance(
      checkInTime: json["checkInTime"],
      checkInLocation: json["checkInLocation"],
      checkOutTime: json["checkOutTime"],
      checkOutLocation: json["checkOutLocation"],
      LogTime: json["LogTime"],
      checkOutInput: json["checkOutInput"],
      checkInInput: json["checkInInput"],
      punctual: json["punctual"],
    );
  }

  Map<String, dynamic> toMap() => {
        "checkInTime": checkInTime,
        "checkInLocation": checkInLocation,
        "checkOutTime": checkOutTime,
        "checkOutLocation": checkOutLocation,
        "LogTime": LogTime,
        "punctual": punctual,
        "checkOutInput": checkOutInput,
        "checkInInput": checkInInput,
      };
}

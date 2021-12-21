import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

LogModel logModelFromMap(String str) => LogModel.fromMap(json.decode(str));

String logModelToMap(LogModel data) => json.encode(data.toMap());

class LogModel {
  LogModel({
    @required this.type,
    @required this.createdBy,
    @required this.timeStamp,
    @required this.bookingId,
    @required this.activityName,
    @required this.employeeName,
  });

  LogType type;
  String createdBy;
  String timeStamp;
  String bookingId;
  String activityName;
  String employeeName;

  factory LogModel.fromMap(Map<String, dynamic> json) => LogModel(
        type: json["type"],
        createdBy: json["createdBy"],
        timeStamp: json["timeStamp"],
        bookingId: json["bookingId"],
        activityName: json["activityName"],
        employeeName: json["employeeName"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "createdBy": createdBy,
        "timeStamp": timeStamp,
        "bookingId": bookingId,
        "activityName": activityName,
        "employeeName": employeeName,
      };
}

convertToEnum(String e) {
  switch (e) {
    case "bookingCreated":
      return LogType.bookingCreated;
    case "bookingEdited":
      return LogType.bookingEdited;
    case "bookingDeleted":
      return LogType.bookingDeleted;
    case "signedIn":
      return LogType.signedIn;
    case "signedOut":
      return LogType.signedOut;
    case "addActivity":
      return LogType.addActivity;
    case "editActivity":
      return LogType.editActivity;
    case "addEmployee":
      return LogType.addEmployee;
    case "editEmployee":
      return LogType.editEmployee;
    case "deleteEmployee":
      return LogType.deleteEmployee;
  }
}

convertToString(LogType e) {
  switch (e) {
    case LogType.bookingCreated:
      return "bookingCreated";
    case LogType.bookingEdited:
      return "bookingEdited";
    case LogType.bookingDeleted:
      return "bookingDeleted";
    case LogType.signedIn:
      return "signedIn";
    case LogType.signedOut:
      return "signedOut";
    case LogType.addActivity:
      return "addActivity";
    case LogType.editActivity:
      return "editActivity";
    case LogType.addEmployee:
      return "addEmployee";
    case LogType.editEmployee:
      return "editEmployee";
    case LogType.deleteEmployee:
      return "deleteEmployee";
  }
}

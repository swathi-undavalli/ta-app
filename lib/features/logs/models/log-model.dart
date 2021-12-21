import 'package:meta/meta.dart';
import 'dart:convert';

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

  Type type;
  String createdBy;
  String timeStamp;
  String bookingId;
  String activityName;
  String employeeName;

  factory LogModel.fromMap(Map<String, dynamic> json) => LogModel(
    type: Type.fromMap(json["type"]),
    createdBy: json["createdBy"],
    timeStamp: json["timeStamp"],
    bookingId: json["bookingId"],
    activityName: json["activityName"],
    employeeName: json["employeeName"],
  );

  Map<String, dynamic> toMap() => {
    "type": type.toMap(),
    "createdBy": createdBy,
    "timeStamp": timeStamp,
    "bookingId": bookingId,
    "activityName": activityName,
    "employeeName": employeeName,
  };
}

class Type {
  Type({
    @required this.typeEnum,
  });

  String typeEnum;

  factory Type.fromMap(Map<String, dynamic> json) => Type(
    typeEnum: json["enum"],
  );

  Map<String, dynamic> toMap() => {
    "enum": typeEnum,
  };
}

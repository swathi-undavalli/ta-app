import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:temple_adventures/features/home/model/employee.dart';

AdminPortalModel adminPortalModelFromMap(String str) =>
    AdminPortalModel.fromMap(json.decode(str));

String adminPortalModelToMap(AdminPortalModel data) =>
    json.encode(data.toMap());

class AdminPortalModel {
  AdminPortalModel({
    required this.path,
    this.createdBy,
    required this.filename,
    this.timeStamp,
    this.id
  }) {
    if (timeStamp == null) timeStamp = Timestamp.fromDate(DateTime.now());
    if (createdBy == null) createdBy = currentEmployee!.name;
  }

  String? path;
  String? createdBy;
  String? filename;
  Timestamp? timeStamp;
  String? id;

  factory AdminPortalModel.fromMap(Map<String, dynamic> json) =>
      AdminPortalModel(
        path: json["path"],
        id: json["id"],
        createdBy: json["createdBy"],
        filename: json["filename"],
        timeStamp: json["timeStamp"],
      );

  Map<String, dynamic> toMap() => {
        "path": path,
        "id": id,
        "createdBy": createdBy,
        "filename": filename,
        "timeStamp": timeStamp,
      };
}

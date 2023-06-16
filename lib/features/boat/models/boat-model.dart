// import 'dart:convert';
//
// BoatsModel boatsModelFromMap(String str) =>
//     BoatsModel.fromMap(json.decode(str));
//
// String boatsModelToMap(BoatsModel data) => json.encode(data.toMap());
//
// class BoatsModel {
//   BoatsModel({
//     this.id,
//     this.boatName,
//     this.captainId,
//     this.capacity,
//   });
//
//   String? id;
//   String? boatName;
//   String? captainId;
//   int? capacity;
//
//   factory BoatsModel.fromMap(Map<String, dynamic> json) => BoatsModel(
//         id: json["id"],
//         boatName: json["boatName"],
//         captainId: json["captainId"],
//         capacity: json["capacity"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "boatName": boatName,
//         "captainId": captainId,
//         "capacity": capacity,
//       };
// }

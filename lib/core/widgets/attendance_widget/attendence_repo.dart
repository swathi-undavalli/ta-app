import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:temple_adventures/core/services/firebase_api.dart';
import 'package:temple_adventures/features/attendance/attendance-model.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

class AttendanceRepo {
  static Attendance attendance;

  /// syncs firebase data with local data.
  static synchronize() async {
    //  1. Get Data from firebase.
    //  2. Update the data in local storage.
    try {
      attendance = await getAttendance(DateTime.now());
    } catch (e) {
      print("No attendance data found");
      attendance = Attendance();
      attendance.checkInLocation = null;
      attendance.checkOutLocation = null;
      attendance.checkInTime = null;
      attendance.checkOutTime = null;
      attendance.checkInInput = null;
      attendance.checkOutInput = null;
      attendance.LogTime = Timestamp.now();
    }
  }

  static checkIn() async {
    attendance.checkInTime = Timestamp.now();
    attendance.checkInLocation = getCurrentLocation();
    attendance.checkInInput = "TA-Mobile App";
    await updateAttendance(attendance);
    LogModel logModel = LogModel(type: LogType.signedIn);
    FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());
  }

  static checkOut() async {
    //  1. CheckOut user at current time and location.
    attendance.checkOutTime = Timestamp.now();
    attendance.checkOutLocation = getCurrentLocation();
    attendance.checkOutInput = "TA-Mobile App";
    await updateAttendance(attendance);
    LogModel logModel = LogModel(type: LogType.signedOut);
    FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());
  }

  static getCurrentLocation() {
    return "Temple Adventures Pondicherry";
  }

  static String isValidLocation() {
    //  1. Check weather the location is valid or not.
    return "Temple Adventures Pondicherry";
  }

  static getAttendance(DateTime date) async {
    var data = await FirebaseApi.getAttendance(date);
    print(data.data());
    print("=======================");
    return Attendance.fromMap(data.data());
  }

  static updateAttendance(Attendance attendance) async {
    await FirebaseApi.updateAttendance(attendance);
  }

  static Future<String> getUserPosition() async {
    Position position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("+++++++++++++++++++++++");
    print(position.latitude);
    print(position.longitude);
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Position currentPosition = position;

    Position templeAdventuresPondicherry =
        Position(latitude: 11.9224978, longitude: 79.8280985);
    Position templeAdventuresPondicherryClassRoom =
        Position(latitude: 11.9235666, longitude: 79.827048);
    Position templeAdventuresChennai =
        Position(latitude: 12.940611194153405, longitude: 80.25962182954129);
    Position devHome = Position(latitude: 11.9814072, longitude: 79.8449049);
    Position dashAndSims =
        Position(latitude: 11.9874156, longitude: 79.8371414);
    Position swathiHome = Position(latitude: 16.9529061, longitude: 81.7113184);

    Position kameshHome = Position(latitude: 16.9041354, longitude: 81.6711417);

    print(
        Geo.getDistance(currentPosition, templeAdventuresPondicherryClassRoom));

    if (Geo.getDistance(currentPosition, templeAdventuresPondicherry) <= 150) {
      return "Pondicherry";
    }
    if (Geo.getDistance(currentPosition, devHome) <= 150) {
      return "Dev Home Aurovelli";
    }
    if (Geo.getDistance(
            currentPosition, templeAdventuresPondicherryClassRoom) <=
        150) {
      return "TA Pondicherry";
    }
    if (Geo.getDistance(currentPosition, templeAdventuresChennai) <= 150) {
      return "TA Chennai";
    }
    if (Geo.getDistance(currentPosition, dashAndSims) <= 150) {
      return "Dash & Sims PVT LTD";
    }
    if (Geo.getDistance(currentPosition, swathiHome) <= 150) {
      return "Dev Swathi's Home";
    }
    if (Geo.getDistance(currentPosition, kameshHome) <= 150) {
      return "Dev Kamesh Home";
    }
    return "Invalid Location";
  }
}

class Geo {
  static getDistance(Position pos1, Position pos2) {
    var lat1 = pos1.latitude;
    var lat2 = pos2.latitude;
    var lon1 = pos1.longitude;
    var lon2 = pos2.longitude;

    var earthRadiusKm = 6371;

    var dLat = degreesToRadians(lat2 - lat1);
    var dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) *
            math.sin(dLon / 2) *
            math.cos(lat1) *
            math.cos(lat2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c * 1000;
  }

  static degreesToRadians(degrees) {
    return degrees * math.pi / 180;
  }
}

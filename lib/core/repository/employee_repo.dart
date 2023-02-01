import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temple_adventures/core/services/firebase_api.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class EmployeeRepo {
  static String? employeeID;
  static GetStorage _getStorage = GetStorage();
  static String _employeeKey = "employeeID";

  static initiateRepo(String? employeeId) {
    employeeID = employeeId;
    _getStorage.write(_employeeKey, employeeID);
  }

  static getEmployee(String employeeID) async {
    //print("getEmployee");
    //print(employeeID);
    var data = await FirebaseApi.getEmployeeFullInformation(employeeID);
    //print(data.data());
    return Employee.fromMap(data.data()!);
  }

  static updateEmployee(Employee employee) async {
    await FirebaseApi.getEmployeeFullInformation(employeeID);
  }

  /// Get user information form local data persistance.
  /// Should call at the start of the App.

  static synchronise() async {
    var notificationStatus = await Permission.notification.status;
    //log(notificationStatus.toString());
    //log("Notification check");
    //print("synchronise EmployeeRepo");
    if(notificationStatus.isGranted){
      await Permission.notification.request();
    }
    var empID = _getStorage.read(_employeeKey);
    //print(empID);
    if (empID != null) {
      currentEmployee = await getEmployee(empID);
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        //print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        //print('User granted provisional permission');
      } else {
        //print('User declined or has not accepted permission');
      }
      if (currentEmployee!.accessLevels!.notifications == true) {
        FirebaseMessaging.instance
            .subscribeToTopic("newBooking")
            .whenComplete(() => showToast("Subscribed"));
      }
    }
  }
}

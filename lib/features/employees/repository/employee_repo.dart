import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/utils.dart';
import '../../bookings/repository/booking_repo.dart';
import '../model/employee.dart';

class EmployeeRepo {
  static String? employeeID;
  static final GetStorage _getStorage = GetStorage();
  static const String _employeeKey = 'employeeID';

  static initiateRepo(String? employeeId) {
    employeeID = employeeId;
    _getStorage.write(_employeeKey, employeeID);
  }

  static getEmployee(String employeeID) async {
    var data = await BookingRepo.getEmployeeFullInformation(employeeID);
    return Employee.fromMap(data.data()!);
  }

  static updateEmployee(Employee employee) async {
    await BookingRepo.getEmployeeFullInformation(employeeID);
  }

  /// Get user information form local data persistence.
  /// Should call at the start of the App.

  static synchronise() async {
    var notificationStatus = await Permission.notification.status;
    if (notificationStatus.isGranted) {
      await Permission.notification.request();
    }
    var empID = _getStorage.read(_employeeKey);
    if (empID != null) {
      currentEmployee = await getEmployee(empID);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      } else {}
      if (currentEmployee!.accessLevels!.notifications == true) {
        FirebaseMessaging.instance.subscribeToTopic('newBooking').whenComplete(() => showToast('Subscribed'));
      }
    }
  }
}

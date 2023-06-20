import 'package:flutter/material.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class EmployeeAccess extends StatelessWidget {
  final Widget child;
  final bool access;
  final bool? showMessage;

  EmployeeAccess({required this.child, required this.access, this.showMessage});

  @override
  Widget build(BuildContext context) {
    if ((!access) && showMessage != null && showMessage!)
      return SizedBox(
        height: 300,
        child: Center(
          child: Text("You Don't have Access to this page"),
        ),
      );
    if (access) return child;
    return SizedBox();
  }

  static run({
    required Function function,
    required bool? access,
  }) {
    if (access != null && access) function();
  }
}

class AccessRights {
  static AccessLevels? get accessLevel {
    if(currentEmployee == null){
      currentEmployee = Employee(id: "");
    }
    return currentEmployee!.accessLevels;
  }

  static bool get viewBookings => accessLevel?.viewBookings ?? false;

  static bool get createBookings => accessLevel?.createBookings ?? false;

  static bool get editBookings => accessLevel?.editBookings ?? false;

  static bool get viewEmployees => accessLevel?.viewEmployees ?? false;

  static bool get createEmployees => accessLevel?.createEmployees ?? false;

  static bool get editEmployees => accessLevel?.editEmployees ?? false;

  static bool get personalProfileEdit =>
      accessLevel?.personalProfileEdit ?? false;

  static bool get personalAttendanceReport =>
      accessLevel?.personalAttendanceReport ?? false;

  static bool get attendanceReport => accessLevel?.attendanceReport ?? false;

  static bool get weatherReport => accessLevel?.weatherReport ?? false;

  static bool get editActivityPrices =>
      accessLevel?.editActivityPrices ?? false;

  static bool get addActivity => accessLevel?.addActivity ?? false;
}

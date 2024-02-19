import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/employees/model/employee.dart';

class EmployeeAccess extends StatelessWidget {
  final Widget child;
  final bool access;
  final bool? showMessage;

  const EmployeeAccess({Key? key, required this.child, required this.access, this.showMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((!access) && showMessage != null && showMessage!) {
      return SizedBox(
        height: Get.height,
        child: const Center(
          child: Text("You Don't have Access to this page"),
        ),
      );
    }
    if (access) return child;
    return const SizedBox();
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
    currentEmployee ??= Employee(id: '');
    return currentEmployee!.accessLevels;
  }

  static bool get viewBookings => accessLevel?.viewBookings ?? false;

  static bool get createBookings => accessLevel?.createBookings ?? false;

  static bool get editBookings => accessLevel?.editBookings ?? false;

  static bool get viewEmployees => accessLevel?.viewEmployees ?? false;

  static bool get createEmployees => accessLevel?.createEmployees ?? false;

  static bool get editEmployees => accessLevel?.editEmployees ?? false;

  static bool get personalProfileEdit => accessLevel?.personalProfileEdit ?? false;

  static bool get personalAttendanceReport => accessLevel?.personalAttendanceReport ?? false;

  static bool get attendanceReport => accessLevel?.attendanceReport ?? false;

  static bool get weatherReport => accessLevel?.weatherReport ?? false;

  static bool get editActivityPrices => accessLevel?.editActivityPrices ?? false;

  static bool get addActivity => accessLevel?.addActivity ?? false;

  static bool get boatPlan => accessLevel?.boatPlan ?? false;

  static bool get marketingGallery => accessLevel?.marketingGallery ?? false;

  static bool get offers => accessLevel?.offers ?? false;
}

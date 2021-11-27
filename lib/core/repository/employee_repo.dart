import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:temple_adventures/core/services/firebase_api.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class EmployeeRepo {
  static String employeeID;
  static GetStorage _getStorage = GetStorage();
  static String _employeeKey = "employeeID";

  static initiateRepo(String employeeId) {
    employeeID = employeeId;
    _getStorage.write(_employeeKey, employeeID);
  }

  static getEmployee(String employeeID) async {
    print("getEmployee");
    print(employeeID);
    var data = await FirebaseApi.getEmployeeFullInformation(employeeID);
    print(data.data());
    return Employee.fromMap(data.data());
  }

  static updateEmployee(Employee employee) async {
    await FirebaseApi.getEmployeeFullInformation(employeeID);
  }

  /// Get user information form local data persistance.
  /// Should call at the start of the App.
  static synchronise() async {
    print("synchronise EmployeeRepo");
    var empID = _getStorage.read(_employeeKey);

    print(empID);
    if (empID != null) currentEmployee = await getEmployee(empID);
  }
}

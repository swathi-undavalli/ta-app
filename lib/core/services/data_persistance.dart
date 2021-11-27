// import 'package:get_storage/get_storage.dart';
// import 'package:temple_adventures/core/widgets/attendance_widget/attandence_persistence_model.dart';
// import 'package:temple_adventures/core/widgets/attendance_widget/attandence_widget_controller.dart';
// import 'package:temple_adventures/features/home/model/employee.dart';
//
// class DataPersistence {
//   static AttendancePersistenceModel _attendancePersistence;
//   static GetStorage _getStorage = GetStorage();
//   static String _attendanceKey = "attendance";
//   static AttendanceWidgetLogic _attendanceWidgetLogic = AttendanceWidgetLogic();
//
//   /// Used to initiate DataPersistence and updates the HomeLogicController [showCheckIn & showCheckOut] with recent values
//   static initiateDataPersistence() async {
//     print("initiateDataPersistence");
//     await GetStorage.init();
//     var attendance = _getStorage.read(_attendanceKey);
//     print("=============$attendance");
//     if (attendance == null) {
//       _attendancePersistence = AttendancePersistenceModel(
//           lastUpdated: DateTime.now(), showCheckIn: true, showCheckOut: false);
//       _getStorage.write(_attendanceKey, _attendancePersistence.toJson());
//     } else {
//       _attendancePersistence = AttendancePersistenceModel.fromJson(attendance);
//     }
//     print(_attendancePersistence.toJson());
//   }
//
//   /// Used to getAttendance from DataPersistence and updates the HomeLogicController [showCheckIn & showCheckOut].
//   static getAttendanceData() async {
//
//     await initiateDataPersistence();
//     if (_attendancePersistence.lastUpdated.day == DateTime.now().day) {
//       //Opened on the same day
//       _attendanceWidgetLogic.controller.showCheckIn =
//           _attendancePersistence.showCheckIn;
//       _attendanceWidgetLogic.controller.showCheckOut =
//           _attendancePersistence.showCheckOut;
//     } else {
//       //Opened on other days
//       _attendancePersistence.showCheckIn = true;
//       _attendancePersistence.showCheckOut = false;
//       _attendancePersistence.lastUpdated = DateTime.now();
//       _getStorage.write(_attendanceKey, _attendancePersistence.toJson());
//     }
//   }
//
//   /// Used to updateAttendance locally in device. Have to supply the [AttendanceType].
//   static updateAttendanceData(AttendanceType type) {
//     if (AttendanceType.CheckIn == type) {
//       _attendancePersistence.showCheckIn = false;
//       _attendancePersistence.showCheckOut = true;
//     } else {
//       _attendancePersistence.showCheckOut = false;
//       _attendancePersistence.showCheckIn = false;
//     }
//     _attendancePersistence.lastUpdated = DateTime.now();
//     _getStorage.write(_attendanceKey, _attendancePersistence.toJson());
//   }
// }

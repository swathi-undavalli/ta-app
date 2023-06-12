import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/attendance_report_widget/mini_employee_model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/attendance/attendance-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:temple_adventures/features/home/model/employee.dart';

class FirebaseApi {
  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getEmployeeFullInformation(String? employeeID) async {
    return await FirebaseFirestore.instance
        .collection('employees')
        .doc(employeeID)
        // .collection('employeeFullInformation')
        // .doc('employeeData')
        .get();
  }

  static Future<void> updateEmployeeFullInformation(Employee employee) async {
    return await FirebaseFirestore.instance
        .collection('employees')
        .doc(employee.id)
        // .collection('employeeFullInformation')
        // .doc('employeeData')
        .set(employee.toMap());
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAttendance(
      DateTime dateTime) async {
    var date = DateFormat("dd-M-yyyy").format(dateTime);
    return await FirebaseFirestore.instance
        .collection('employees')
        .doc(currentEmployee!.id)
        .collection('attendance')
        .doc(date)
        .get();
  }

  static addNewBooking(BookingModel booking) async {
    log("addNewBooking");

    DocumentReference counterRef =
        FirebaseFirestore.instance.collection('counter').doc("count");
    log("addNewBooking1");

    var bookingId;
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      log("addNewBooking2");
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      Map<String, dynamic> data = counterSnapshot.data() as Map<String, dynamic>;
      log("addNewBooking3");
      int? newBookingID = data["booking"] + 1;
      DocumentReference bookingRef = FirebaseFirestore.instance
          .collection('bookings')
          .doc(newBookingID.toString());
      log("addNewBooking4");
      booking.id = newBookingID.toString();
      log("addNewBooking4adf");
      log(booking.toMap().toString());
      transaction.set(bookingRef, booking.toMap());
      log("addNewBooking5");
      transaction.update(counterRef, {'booking': newBookingID});
      bookingId = newBookingID;
      log("addNewBooking6");
      return newBookingID;
    });
    return bookingId.toString();
  }

  static getDifferenceInSeconds(DateTime shiftTime) {
    int shiftHour = shiftTime.hour;
    int shiftMin = shiftTime.minute;
    int shiftSec = shiftTime.second;

    var now = DateTime.now();
    int nowHour = now.hour;
    int nowMin = now.minute;
    int nowSec = now.second;

    ///convert to seconds:
    int shiftSeconds = (shiftHour * 60 * 60) + (shiftMin * 60) + shiftSec;
    //print(shiftSeconds);

    int nowSeconds = (nowHour * 60 * 60) + (nowMin * 60) + nowSec;
    //print(nowSeconds);

    int diffInSeconds = shiftSeconds - nowSeconds;
    if (diffInSeconds < 0) {
      //print("Late");
    } else if (diffInSeconds == 0) {
      //print("On Time");
    } else {
      //print("Early");
    }
    return diffInSeconds;
  }

  static updateAttendance(Attendance attendance) async {
    var date = DateFormat("dd-M-yyyy").format(DateTime.now());

    if (attendance.checkOutLocation == null) {
      DocumentReference dailyAttendanceLog = FirebaseFirestore.instance
          .collection('dailyAttendanceLogs')
          .doc(date);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var now = DateTime.now();
        var shift = DateTime(0, 0, 0, currentEmployee!.shiftTiming!.hour,
            currentEmployee!.shiftTiming!.minute);
        var present = DateTime(0, 0, 0, now.hour, now.minute);
        var status = "On-Time";
        if (present.difference(shift).inMinutes > 10) status = "Late";
        if (present.difference(shift).inHours > 6) status = "Absent";
        attendance.punctual = status;

        var cData = await FirebaseFirestore.instance
            .collection('employees')
            .doc(currentEmployee!.id)
            .collection('attendanceClock')
            .doc(DateFormat("MM-yyyy").format(DateTime.now()))
            .get();
        Map<String, dynamic>? clockData = cData.data();

        if (clockData == null || clockData["clockDuration"] == null) {
          clockData = {};
          clockData["clockDuration"] =
              getDifferenceInSeconds(currentEmployee!.shiftTiming!);
        } else {
          var clock = clockData["clockDuration"];
          clock = clock + getDifferenceInSeconds(currentEmployee!.shiftTiming!);
          clockData["clockDuration"] = clock;
        }

        FirebaseFirestore.instance
            .collection('employees')
            .doc(currentEmployee!.id)
            .collection('attendanceClock')
            .doc(DateFormat("MM-yyyy").format(DateTime.now()))
            .set(clockData);

        DocumentSnapshot counterSnapshot =
            await transaction.get(dailyAttendanceLog);
        Map<String, dynamic> data = counterSnapshot.data() as Map<String, dynamic>;
        EmployeeMiniModel newData = EmployeeMiniModel(
          shiftTime: DateFormat("hh:mm:ss").format(currentEmployee!.shiftTiming!),
          phone: currentEmployee!.phoneNumber,
          name: currentEmployee!.firstName! + " " + currentEmployee!.lastName!,
          logTime: Timestamp.now(),
          id: currentEmployee!.id,
          punctual: status,
        );
        data[currentEmployee!.id] = newData.toMap();
        transaction.update(dailyAttendanceLog, data);
      });
    }

    await FirebaseFirestore.instance
        .collection('employees')
        .doc(currentEmployee!.id)
        .collection('attendance')
        .doc(date)
        .set(attendance.toMap());
  }

  static uploadPDF(File file, String email, Function onSuccess) async {
    if (file == null) return;
    String fileExtension = file.path.split('.').last;
    String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + "." + fileExtension;

    final metadata = SettableMetadata(
        contentType: lookupMimeType(file.path),
        customMetadata: {'picked-file-path': file.path});

    await FirebaseStorage.instance
        .ref("customers")
        .child("/paperwork")
        .child("/$email")
        .child("/$fileName")
        .putFile(file, metadata)
        .then((TaskSnapshot v) async {
          onSuccess(await v.ref.getDownloadURL());
        })
        .whenComplete(() => showToast("Pdf Upload Success"))
        .onError((dynamic error, stackTrace) async {
          showToast(error.toString());
        })
        .catchError((error) => showToast(error.toString()));
  }

  static uploadIdProof(File file, String email, Function onSuccess) async {
    if (file == null) return;
    String dir = path.dirname(file.path);
    String fileExtension = file.path.split('.').last;
    String fileName = email + "." + fileExtension;

    final metadata = SettableMetadata(
        contentType: lookupMimeType(file.path),
        customMetadata: {'picked-file-path': file.path});

    await FirebaseStorage.instance
        .ref("customers")
        .child("/idProofs")
        .child("/$fileName")
        .putFile(file, metadata)
        .then((TaskSnapshot v) async {
          onSuccess(await v.ref.getDownloadURL());
        })
        .whenComplete(() => showToast("Id proof upload Success"))
        .onError((dynamic error, stackTrace) async {
          showToast(error.toString());
        })
        .catchError((error) => showToast(error.toString()));
  }
}

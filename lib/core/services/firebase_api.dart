import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../features/bookings/models/booking_model.dart';
import '../../features/employees/model/employee.dart';

class FirebaseApi {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getEmployeeFullInformation(String? employeeID) async {
    return await FirebaseFirestore.instance.collection('employees').doc(employeeID).get();
  }

  static Future<void> updateEmployeeFullInformation(Employee employee) async {
    return await FirebaseFirestore.instance.collection('employees').doc(employee.id).set(employee.toMap());
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAttendance(
    DateTime dateTime,
  ) async {
    var date = DateFormat('dd-M-yyyy').format(dateTime);
    return await FirebaseFirestore.instance
        .collection('employees')
        .doc(currentEmployee!.id)
        .collection('attendance')
        .doc(date)
        .get();
  }

  static addNewBooking(Booking booking) async {
    DocumentReference counterRef = FirebaseFirestore.instance.collection('counter').doc('count');

    int? bookingId;
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      Map<String, dynamic> data = counterSnapshot.data() as Map<String, dynamic>;
      int? newBookingID = data['booking'] + 1;

      DocumentReference bookingRef = FirebaseFirestore.instance.collection('bookings').doc(newBookingID.toString());

      booking.id = newBookingID.toString();
      booking.createdAt = DateTime.now();
      transaction.set(bookingRef, booking.toMap());
      transaction.update(counterRef, {'booking': newBookingID});

      bookingId = newBookingID;
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
}

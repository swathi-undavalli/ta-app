import 'package:cloud_firestore/cloud_firestore.dart';

import '../../employees/model/employee.dart';
import '../models/booking_model.dart';

class BookingRepo {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getEmployeeFullInformation(String? employeeID) async {
    return await FirebaseFirestore.instance.collection('employees').doc(employeeID).get();
  }

  static Future<void> updateEmployeeFullInformation(Employee employee) async {
    return await FirebaseFirestore.instance.collection('employees').doc(employee.id).set(employee.toMap());
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

  static Future<void> removeBoat({
    required Booking bookingModel,
    required DateTime selectedDate,
  }) async {
    bookingModel.setBoatInfo(
      selectedDate,
      null,
    );

    await FirebaseFirestore.instance.collection('bookings').doc(bookingModel.id).set(
          bookingModel.toMap(),
        );
  }
}

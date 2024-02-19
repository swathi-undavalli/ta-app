import 'package:intl/intl.dart';

import '../../features/bookings/models/booking_model.dart';

class ItemModel {
  bool expanded;
  final String? name;
  String time;
  String session;
  final String? email;
  final String? bookingID;
  final String? phone;
  final String activity;
  final String colorCode;
  final String price;
  final String date;
  final String cost;
  final String paid;
  final String balance;
  final String? remarks;
  final int? pax;
  final bool registration;
  final String? receiptNo;
  final String? employeeName;
  Booking? bookingModel;

  ItemModel({
    required this.phone,
    required this.activity,
    required this.bookingID,
    required this.colorCode,
    required this.price,
    required this.time,
    required this.session,
    required this.date,
    required this.cost,
    required this.paid,
    required this.receiptNo,
    required this.balance,
    required this.remarks,
    required this.registration,
    this.expanded = false,
    required this.name,
    required this.employeeName,
    required this.pax,
    required this.email,
    this.bookingModel,
  });

  factory ItemModel.fromBooking(Booking bookingModel) {
    getSessions() {
      var d = '';
      if (bookingModel.theoryDate != null) d = '${d}Theory, ';
      if (bookingModel.poolDate != null) d = '${d}Pool, ';
      if (bookingModel.diveDate != null) d = '${d}Dive, ';
      return d.substring(0, d.length - 2);
    }

    getTime() {
      var d = '';
      if (bookingModel.theoryDate != null && bookingModel.theoryDate!.isNotEmpty) {
        d = "$d${DateFormat("hh:mm").format(bookingModel.theoryDate![0]!)}, ";
      }
      if (bookingModel.poolDate != null && bookingModel.poolDate!.isNotEmpty) {
        d = "$d${DateFormat("hh:mm").format(bookingModel.poolDate![0]!)}, ";
      }
      if (bookingModel.diveDate != null && bookingModel.diveDate!.isNotEmpty) {
        d = "$d${DateFormat("hh:mm").format(bookingModel.diveDate![0]!)}, ";
      }
      return d.substring(0, d.length - 2);
    }

    return ItemModel(
      phone: bookingModel.pax![0]['countryCode'] + bookingModel.pax![0]['phoneNumber'],
      bookingID: bookingModel.id,
      activity: bookingModel.activity![0]!.name.toString(),
      price: bookingModel.activity![0]!.price.toString(),
      colorCode: bookingModel.activity![0]!.color.toString(),
      date: bookingModel.bookingDate![0],
      cost: bookingModel.totalCost.toString(),
      paid: bookingModel.paid.toString(),
      balance: bookingModel.balance.toString(),
      registration: true,
      receiptNo: bookingModel.receiptNo,
      name: bookingModel.pax![0]['first-name'],
      pax: bookingModel.noOfPersons,
      email: bookingModel.pax![0]['email'],
      remarks: bookingModel.remarks,
      time: getTime(),
      session: getSessions(),
      employeeName: bookingModel.employeeName,
      bookingModel: bookingModel,
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:get/get_utils/src/extensions/double_extensions.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';

BookingModel bookingModelFromMap(String str) => BookingModel.fromMap(json.decode(str));

String bookingModelToMap(BookingModel data) => json.encode(data.toMap());

class BookingModel {
  BookingModel({
    this.activity,
    this.pax,
    this.noOfPersons,
    this.location = "Pondicherry",
    this.discount = 0,
    this.price = 0,
    this.tax = 18,
    this.paid = 0,
    this.id,
    this.paymentMode,
    this.paymentTransactionId,
    this.poolDate,
    this.diveDate,
    this.theoryDate,
    this.bookingDate,
    this.receiptNo,
    this.discountType = "%",
    this.remarks,
    this.employeeName,
    this.idProofs,
    // this.payments,
  });

  List<ActivityModel> activity;
  List<Map<String, dynamic>> pax;
  List<String> idProofs;
  int noOfPersons;
  double discount;
  double price;
  double tax;
  double paid;
  String id;
  String paymentMode;
  String location;
  String remarks;
  String paymentTransactionId;
  String receiptNo;
  String employeeName;
  List<DateTime> poolDate;
  List<DateTime> diveDate;
  List<DateTime> theoryDate;
  List<String> bookingDate;
  String discountType;

  factory BookingModel.fromMap(Map<String, dynamic> json) {
    //log("fromMap");
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    double checkDouble(dynamic value) {
      if (value is String) {
        return double.parse(value);
      } else {
        return value.toDouble();
      }
    }


    return BookingModel(
      activity: List<ActivityModel>.from(
          json["activity"].map((x) => ActivityModel.fromMap(x))),
      pax: List<Map<String, dynamic>>.from(json["PAX"].map((x) => x)),
      noOfPersons: json["noOfPersons"],
      discount: json["discount"] * 1.0,
      discountType: json["discountSwitch"],
      price: json["price"] * 1.0,
      tax: json["tax"] * 1.0,
      paid: json["paid"] * 1.0,
      paymentMode: json["paymentMode"],
      receiptNo: json["receiptNo"],
      remarks: json["remarks"],
      employeeName: json["employeeName"],
      id: json["id"],
      location: json["location"],
      paymentTransactionId: json["paymentTransactionId"],
      bookingDate: List<String>.from(json["bookingDate"].map((x) => x)),
      idProofs: List<String>.from(json["idProofs"] ?? [].map((x) => x)),
      // payments: List<dynamic>.from(json["payments"] ?? [].map((x) => x * 1.0)),
      theoryDate: List<DateTime>.from(
          json["theoryDate"].map((x) => parseDateOrNull(x))),
      poolDate:
          List<DateTime>.from(json["poolDate"].map((x) => parseDateOrNull(x))),
      diveDate:
          List<DateTime>.from(json["diveDate"].map((x) => parseDateOrNull(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "activity": List<dynamic>.from(activity.map((x) => x.toMap())),
        "PAX": List<dynamic>.from(pax.map((x) => x)),
        "noOfPersons": noOfPersons,
        "discount": discount,
        "price": price,
        "id": id,
        "remarks": remarks,
        "employeeName": employeeName,
        "discountSwitch": discountType,
        "tax": tax,
        "paid": paid,
        "paymentMode": paymentMode,
        "receiptNo": receiptNo,
        "bookingDate": List<String>.from(bookingDate.map((x) => x)),
        "idProofs": List<String>.from(idProofs ?? [].map((x) => x)),
        // "payments": List<dynamic>.from(payments ?? [].map((x) => x)),
        "location": location,
        "paymentTransactionId": paymentTransactionId,
        "theoryDate":
            List<String>.from((theoryDate ?? []).map((x) => toDateOrNull(x))),
        "poolDate":
            List<String>.from((poolDate ?? []).map((x) => toDateOrNull(x))),
        "diveDate":
            List<String>.from((diveDate ?? []).map((x) => toDateOrNull(x))),
      };

  double get balance {
    double balance = price;

    balance = balance * (noOfPersons ?? 1);

    /// Add Tax
    if (tax != null && tax != 0) {
      balance += balance * (tax / 100);
    }

    /// Deduct Discount
    if (discountType != null) {
      if (discountType == "%")
        balance -= balance * (discount / 100);
      else
        balance = balance - discount;
    }

    /// Deduct paying now
    if (paid != null) {
      balance -= paid;
    }
    return balance.toPrecision(2);
  }

  double get totalCost {
    double total = price;
    total = total * (noOfPersons ?? 1);

    /// Add Tax
    if (tax != null && tax != 0) {
      total += total * (tax / 100);
    }

    /// Deduct Discount
    if (discountType != null) {
      if (discountType == "%")
        total -= total * (discount / 100);
      else
        total = total - discount;
      //print("total $total");
    }
    //print(total);

    //print(tax);
    //print(total);
    return total;
  }

  String toDateOrNull(DateTime date) {
    if (date == null) return null;
    return date.toIso8601String();
  }
}

/*class BookingModel {
  BookingModel({
    this.activity,
    this.pax,
    this.noOfPersons,
    this.location,
    this.discount,
    this.price,
    this.tax,
    this.totalCost,
    this.paid,
    this.balance,
    this.paymentMode,
    this.paymentTransactionId,
    this.poolDate,
    this.diveDate,
    this.theoryDate,
    this.bookingDate,
    this.receiptNo,
  });

  List<ActivityModel> activity;
  List<Map<String, dynamic>> pax;
  int noOfPersons;
  double discount;
  double price;
  double tax;
  double totalCost;
  double paid;
  double balance;
  String paymentMode;
  String location;
  String paymentTransactionId;
  String receiptNo;
  DateTime poolDate;
  DateTime diveDate;
  DateTime theoryDate;
  List<String> bookingDate;

  factory BookingModel.fromMap(Map<String, dynamic> json) {
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    return BookingModel(
      activity: List<ActivityModel>.from(
          json["activity"].map((x) => ActivityModel.fromMap(x))),
      pax: List<Map<String, dynamic>>.from(json["PAX"].map((x) => x)),
      noOfPersons: json["noOfPersons"],
      discount: json["discount"].toDouble(),
      price: json["price"].toDouble(),
      tax: json["tax"].toDouble(),
      totalCost: json["totalCost"].toDouble(),
      paid: json["paid"].toDouble(),
      balance: json["balance"].toDouble(),
      paymentMode: json["paymentMode"],
      receiptNo: json["receiptNo"],
      location: json["location"],
      paymentTransactionId: json["paymentTransactionId"],
      bookingDate: List<String>.from(json["bookingDate"].map((x) => x)),
      poolDate: parseDateOrNull(json["poolDate"]),
      diveDate: parseDateOrNull(json["diveDate"]),
      theoryDate: parseDateOrNull(json["theoryDate"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "activity": List<dynamic>.from(activity.map((x) => x.toMap())),
        "PAX": List<dynamic>.from(pax.map((x) => x)),
        "noOfPersons": noOfPersons,
        "discount": discount,
        "price": price,
        "tax": tax,
        "totalCost": totalCost,
        "paid": paid,
        "balance": balance,
        "paymentMode": paymentMode,
        "receiptNo": receiptNo,
        "bookingDate": List<String>.from(bookingDate.map((x) => x)),
        "location": location,
        "paymentTransactionId": paymentTransactionId,
        "poolDate": toDateOrNull(poolDate),
        "theoryDate": toDateOrNull(theoryDate),
        "diveDate": toDateOrNull(diveDate),
      };

  toDateOrNull(DateTime date) {
    if (date == null) return null;
    return date.toIso8601String();
  }
}*/

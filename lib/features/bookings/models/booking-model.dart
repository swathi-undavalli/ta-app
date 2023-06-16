import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/double_extensions.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';

BookingModel bookingModelFromMap(String str) =>
    BookingModel.fromMap(json.decode(str));

String bookingModelToMap(BookingModel data) => json.encode(data.toMap());

class BookingModel {
  BookingModel({
    this.activity,
    this.pax,
    this.noOfPersons = 1,
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
    this.payments,
    this.createdAt,
    this.cancelBooking,
    this.cancellationReason,
    this.boatDetails,
  });

  List<ActivityModel?>? activity;
  List<Map<String, dynamic>>? pax;
  List<PaymentModel>? payments;
  List<String?>? idProofs;
  int? noOfPersons;
  double? discount;
  double? price;
  double? tax;
  double? paid;
  String? id;
  String? paymentMode;
  String? location;
  String? remarks;
  String? paymentTransactionId;
  String? receiptNo;
  String? employeeName;
  List<DateTime?>? poolDate;
  List<DateTime?>? diveDate;
  List<DateTime?>? theoryDate;
  List<String>? bookingDate;
  String? discountType;
  DateTime? createdAt;
  bool? cancelBooking;
  String? cancellationReason;
  BoatDetails? boatDetails;

  factory BookingModel.fromMap(Map<String, dynamic> json) {
    //log("fromMap");
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    return BookingModel(
      pax: List<Map<String, dynamic>>.from(json["PAX"].map((x) => x)),
      activity: List<ActivityModel>.from(
          json["activity"].map((x) => ActivityModel.fromMap(x))),
      payments: List<PaymentModel>.from(
          (json["payments"] ?? []).map((x) => PaymentModel.fromMap(x))),
      noOfPersons: json["noOfPersons"],
      createdAt: parseDateOrNull(json["createdAt"]),
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
      cancelBooking: json["cancelBooking"],
      cancellationReason: json["cancellationReason"],
      boatDetails: BoatDetails.fromJson(json["boatDetails"] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "activity": List<dynamic>.from((activity ?? []).map((x) => x!.toMap())),
      "PAX": List<dynamic>.from((pax ?? []).map((x) => x)),
      "noOfPersons": noOfPersons,
      "createdAt": toDateOrNull(createdAt),
      "discount": discount,
      "price": price,
      "id": id,
      "payments": List<dynamic>.from((payments ?? []).map((x) => x.toMap())),
      "remarks": remarks,
      "employeeName": employeeName,
      "discountSwitch": discountType,
      "tax": tax,
      "paid": paid,
      "paymentMode": paymentMode,
      "receiptNo": receiptNo,
      "bookingDate": List<String>.from((bookingDate ?? []).map((x) => x)),
      "idProofs": List<String>.from((idProofs ?? []).map((x) => x)),
      "location": location,
      "paymentTransactionId": paymentTransactionId,
      "theoryDate":
          List<String>.from((theoryDate ?? []).map((x) => toDateOrNull(x))),
      "poolDate":
          List<String>.from((poolDate ?? []).map((x) => toDateOrNull(x))),
      "diveDate":
          List<String>.from((diveDate ?? []).map((x) => toDateOrNull(x))),
      "cancelBooking": cancelBooking,
      "cancellationReason": cancellationReason,
      "boatDetails": boatDetails?.toMap(),
    };
  }

  double get balance {
    double balance = price!;

    balance = balance * (noOfPersons ?? 1);

    /// Add Tax
    if (tax != null && tax != 0) {
      balance += balance * (tax! / 100);
    }

    /// Deduct Discount
    if (discountType != null) {
      if (discountType == "%")
        balance -= balance * (discount! / 100);
      else
        balance = balance - discount!;
    }

    /// Deduct paying now
    if (paid != null) {
      balance = balance.floorToDouble() - paid!;
    }
    return balance;
  }

  double get totalCost {
    double total = price!;
    total = total * (noOfPersons ?? 1);

    /// Add Tax
    if (tax != null && tax != 0) {
      total += total * (tax! / 100);
    }

    /// Deduct Discount
    if (discountType != null) {
      if (discountType == "%")
        total -= total * (discount! / 100);
      else
        total = total - discount!;
      //print("total $total");
    }
    return total.floorToDouble();
  }

  String? toDateOrNull(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }

  bool get hasTheorySession => theoryDate != null;

  bool get hasPoolSession => poolDate != null;

  bool get hasDiveSession => diveDate != null;

  bool get hasMedicalIssues {
    bool val = false;
    if (pax!.length > 1) {
      pax!.sublist(1).forEach((e) {
        if (e['needDoctor'] != null && e['needDoctor'] == true) {
          print("${e['needDoctor']} kamba ${e['first-name']}");
          val = true;
        }
      });
    }

    return val;
  }
}

class PaymentModel {
  PaymentModel({
    this.amount,
    this.collectedBy,
    this.reciptNo,
    this.referenceNo,
    this.remarks,
    this.paymentMode,
    this.time,
  });

  double? amount;
  String? collectedBy;
  String? reciptNo;
  String? referenceNo;
  String? paymentMode;
  String? remarks;
  DateTime? time;

  String? toDateOrNull(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }

  factory PaymentModel.fromMap(Map<String, dynamic> json) {
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    return PaymentModel(
      amount: (json["amount"] ?? 0.0) * 1.0,
      collectedBy: json["collectedBy"],
      reciptNo: json["reciptNo"],
      remarks: json["remarks"],
      referenceNo: json["referenceNo"],
      paymentMode: json["paymentMode"],
      time: parseDateOrNull(json["time"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "collectedBy": collectedBy,
        "time": toDateOrNull(time),
        "reciptNo": reciptNo,
        "referenceNo": referenceNo,
        "remarks": remarks,
        "paymentMode": paymentMode,
      };
}

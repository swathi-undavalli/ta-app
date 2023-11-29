import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';

import '../../boat/models/boat_details.dart';
import 'activity_model.dart';

Booking bookingModelFromMap(String str) => Booking.fromMap(json.decode(str));

String bookingModelToMap(Booking data) => json.encode(data.toMap());

class Booking {
  Booking({
    this.activity,
    this.pax,
    this.noOfPersons = 1,
    this.location = 'Pondicherry',
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
    this.discountType = '%',
    this.remarks,
    this.employeeName,
    this.idProofs,
    this.payments,
    this.createdAt,
    this.cancelBooking,
    this.cancellationReason,
    this.boatDetails,
    this.parentBookingId,
    this.isQuickBooking = false,
  });

  List<Activity?>? activity;
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
  bool isQuickBooking;
  String? parentBookingId;

  Booking copyWith({
    List<Activity?>? activity,
    List<Map<String, dynamic>>? pax,
    List<PaymentModel>? payments,
    List<String?>? idProofs,
    int? noOfPersons,
    double? discount,
    double? price,
    double? tax,
    double? paid,
    String? id,
    String? paymentMode,
    String? location,
    String? remarks,
    String? paymentTransactionId,
    String? receiptNo,
    String? employeeName,
    List<DateTime?>? poolDate,
    List<DateTime?>? diveDate,
    List<DateTime?>? theoryDate,
    List<String>? bookingDate,
    String? discountType,
    DateTime? createdAt,
    bool? cancelBooking,
    String? cancellationReason,
    BoatDetails? boatDetails,
    bool? isQuickBooking,
    String? parentBookingId,
  }) =>
      Booking(
        activity: activity ?? this.activity,
        pax: pax ?? this.pax,
        noOfPersons: noOfPersons ?? this.noOfPersons,
        location: location ?? this.location,
        discount: discount ?? this.discount,
        price: price ?? this.price,
        tax: tax ?? this.tax,
        paid: paid ?? this.paid,
        id: id ?? this.id,
        paymentMode: paymentMode ?? this.paymentMode,
        paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
        poolDate: poolDate ?? this.poolDate,
        diveDate: diveDate ?? this.diveDate,
        theoryDate: theoryDate ?? this.theoryDate,
        bookingDate: bookingDate ?? this.bookingDate,
        receiptNo: receiptNo ?? this.receiptNo,
        discountType: discountType ?? this.discountType,
        remarks: remarks ?? this.remarks,
        employeeName: employeeName ?? this.employeeName,
        idProofs: idProofs ?? this.idProofs,
        payments: payments ?? this.payments,
        createdAt: createdAt ?? this.createdAt,
        cancelBooking: cancelBooking ?? this.cancelBooking,
        cancellationReason: cancellationReason ?? this.cancellationReason,
        boatDetails: boatDetails ?? this.boatDetails,
        parentBookingId: parentBookingId ?? this.parentBookingId,
        isQuickBooking: isQuickBooking ?? this.isQuickBooking,
      );

  factory Booking.fromMap(Map<String, dynamic> json) {
    log("fromMap");
    parseDateOrNull(date) {
      if (date == null) return null;
      return DateTime.parse(date);
    }

    return Booking(
      pax: List<Map<String, dynamic>>.from(json['PAX'].map((x) => x)),
      activity: List<Activity>.from(json['activity'].map((x) => Activity.fromMap(x))),
      payments: List<PaymentModel>.from((json['payments'] ?? []).map((x) => PaymentModel.fromMap(x))),
      noOfPersons: json['noOfPersons'],
      createdAt: parseDateOrNull(json['createdAt']),
      discount: json['discount'] * 1.0,
      discountType: json['discountSwitch'],
      price: json['price'] * 1.0,
      tax: json['tax'] * 1.0,
      paid: json['paid'] * 1.0,
      paymentMode: json['paymentMode'],
      receiptNo: json['receiptNo'],
      remarks: json['remarks'],
      isQuickBooking: json['isQuickBooking'] ?? false,
      employeeName: json['employeeName'],
      id: json['id'],
      location: json['location'],
      parentBookingId: json['parentBookingId'],
      paymentTransactionId: json['paymentTransactionId'],
      bookingDate: List<String>.from(json['bookingDate'].map((x) => x)),
      idProofs: List<String>.from(json['idProofs'] ?? [].map((x) => x)),
      theoryDate: List<DateTime>.from(json['theoryDate'].map((x) => parseDateOrNull(x))),
      poolDate: List<DateTime>.from(json['poolDate'].map((x) => parseDateOrNull(x))),
      diveDate: List<DateTime>.from(json['diveDate'].map((x) => parseDateOrNull(x))),
      cancelBooking: json['cancelBooking'],
      cancellationReason: json['cancellationReason'],
      boatDetails: BoatDetails.fromJson(json['boatDetails']),
    );
  }

  bool get isDSD => activity?[0]?.name?.toLowerCase() == 'Discover scuba diving'.toLowerCase();

  Map<String, dynamic> toMap() {
    return {
      'activity': List<dynamic>.from((activity ?? []).map((x) => x!.toMap())),
      'PAX': List<dynamic>.from((pax ?? []).map((x) => x)),
      'noOfPersons': noOfPersons,
      'createdAt': toDateOrNull(createdAt),
      'discount': discount,
      'price': price,
      'id': id,
      'payments': List<dynamic>.from((payments ?? []).map((x) => x.toMap())),
      'remarks': remarks,
      'isQuickBooking': isQuickBooking,
      'employeeName': employeeName,
      'discountSwitch': discountType,
      'tax': tax,
      'paid': paid,
      'paymentMode': paymentMode,
      'receiptNo': receiptNo,
      'bookingDate': List<String>.from((bookingDate ?? []).map((x) => x)),
      'idProofs': List<String>.from((idProofs ?? []).map((x) => x)),
      'location': location,
      'paymentTransactionId': paymentTransactionId,
      'theoryDate': List<String>.from((theoryDate ?? []).map((x) => toDateOrNull(x))),
      'poolDate': List<String>.from((poolDate ?? []).map((x) => toDateOrNull(x))),
      'diveDate': List<String>.from((diveDate ?? []).map((x) => toDateOrNull(x))),
      'cancelBooking': cancelBooking,
      'parentBookingId': parentBookingId,
      'cancellationReason': cancellationReason,
      'boatDetails': boatDetails?.toMap(),
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
      if (discountType == '%') {
        balance -= balance * (discount! / 100);
      } else {
        balance = balance - discount!;
      }
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
      if (discountType == '%') {
        total -= total * (discount! / 100);
      } else {
        total = total - discount!;
      }
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
          val = true;
        }
      });
    }

    return val;
  }

  Instructor? get instructor {
    if (boatDetails?.instructors?.isEmpty ?? false) return null;
    return boatDetails?.instructors?[0];
  }

  BoatInfo? getBoatInfo(DateTime date) {
    String d = DateFormat('dd-MM-yyyy').format(date);
    if (boatDetails?.boat?[d] == null) return null;
    return BoatInfo.fromMap(boatDetails?.boat?[d]);
  }

  void setBoatInfo(DateTime date, BoatInfo? boatInfo) {
    String d = DateFormat('dd-MM-yyyy').format(date);
    boatDetails?.boat ??= {};
    boatDetails?.boat?[d] = boatInfo?.toMap();
  }

  InstructorTanks? getInstructorTanks(DateTime date) {
    String d = DateFormat('dd-MM-yyyy').format(date);
    if (boatDetails?.instructorTanks?[d] == null) return null;
    return InstructorTanks.fromMap(boatDetails?.instructorTanks?[d]);
  }

  int? getStatus(DateTime date) {
    String d = DateFormat('dd-MM-yyyy').format(date);
    if (boatDetails?.status?[d] == null) return null;
    return boatDetails?.status?[d];
  }

  void setInstructorTanks(DateTime date, InstructorTanks instructorTanks) {
    String d = DateFormat('dd-MM-yyyy').format(date);
    boatDetails?.instructorTanks ??= {};
    boatDetails?.instructorTanks?[d] = instructorTanks.toMap();
  }

  void setStatus(DateTime date, int status) {
    String d = DateFormat('dd-MM-yyyy').format(date);
    boatDetails?.status ??= {};
    boatDetails?.status?[d] = status;
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
      amount: (json['amount'] ?? 0.0) * 1.0,
      collectedBy: json['collectedBy'],
      reciptNo: json['reciptNo'],
      remarks: json['remarks'],
      referenceNo: json['referenceNo'],
      paymentMode: json['paymentMode'],
      time: parseDateOrNull(json['time']),
    );
  }

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'collectedBy': collectedBy,
        'time': toDateOrNull(time),
        'reciptNo': reciptNo,
        'referenceNo': referenceNo,
        'remarks': remarks,
        'paymentMode': paymentMode,
      };
}

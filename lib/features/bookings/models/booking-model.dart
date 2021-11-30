import 'dart:convert';

import 'package:temple_adventures/features/bookings/models/activity-model.dart';

BookingModel bookingModelFromMap(String str) =>
    BookingModel.fromMap(json.decode(str));

String bookingModelToMap(BookingModel data) => json.encode(data.toMap());

class BookingModel {
  BookingModel({
    this.activity,
    this.pax,
    this.noOfPersons,
    this.location,
    this.discount,
    this.price,
    this.tax,
    this.payingNow,
    this.id,
    this.paymentMode,
    this.paymentTransactionId,
    this.poolDate,
    this.diveDate,
    this.theoryDate,
    this.bookingDate,
    this.receiptNo,
    this.discountType,
    this.remarks,
  });

  List<ActivityModel> activity;
  List<Map<String, dynamic>> pax;
  int noOfPersons;
  double discount;
  double price;
  double tax;
  double payingNow;
  String id;
  String paymentMode;
  String location;
  String remarks;
  String paymentTransactionId;
  String receiptNo;
  DateTime poolDate;
  DateTime diveDate;
  DateTime theoryDate;
  List<String> bookingDate;
  String discountType;

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
      discountType: json["discountSwitch"],
      price: json["price"].toDouble(),
      tax: json["tax"].toDouble(),
      payingNow: json["paid"].toDouble(),
      paymentMode: json["paymentMode"],
      receiptNo: json["receiptNo"],
      remarks: json["remarks"],
      id: json["id"],
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
        "id": id,
        "remarks": remarks,
        "discountSwitch": discountType,
        "tax": tax,
        "paid": payingNow,
        "paymentMode": paymentMode,
        "receiptNo": receiptNo,
        "bookingDate": List<String>.from(bookingDate.map((x) => x)),
        "location": location,
        "paymentTransactionId": paymentTransactionId,
        "poolDate": toDateOrNull(poolDate),
        "theoryDate": toDateOrNull(theoryDate),
        "diveDate": toDateOrNull(diveDate),
      };

  double get balance {
    double balance = price;

    balance = balance * (noOfPersons ?? 1);

    /// Deduct Discount
    if (discountType != null) {
      if (discountType == "%")
        balance -= balance * discount / 100;
      else
        balance = balance - discount;
    }

    /// Add Tax
    if (tax != null && tax != 0) {
      balance += balance * tax / 100;
    }

    /// Deduct paying now
    if (payingNow != null) {
      balance -= payingNow;
    }
    return balance;
  }

  double get totalCost {
    print("================");
    // print(price);
    // print(noOfPersons);
    // print(discountType);
    // print(discount);
    // print(tax);
    double total = price;
    total = total * (noOfPersons ?? 1);
    // print("================");
    // print(price);
    // print(noOfPersons);
    // print(discountType);
    // print(discount);
    // print(tax);

    /// Deduct Discount
    if (discountType != null) {
      if (discountType == "%")
        total -= total * discount / 100;
      else
        total = total - discount;
      print("total $total");
    }
    print(total);

    /// Add Tax
    if (tax != null && tax != 0) {
      total += total * tax / 100;
    }
    print(total);
    return total;
  }

  toDateOrNull(DateTime date) {
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

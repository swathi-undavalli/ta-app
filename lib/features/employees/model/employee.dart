import 'package:cloud_firestore/cloud_firestore.dart';

import '../../boat/models/boat_details.dart';

Employee? currentEmployee;

class Employee {
  Employee({
    required this.id,
    this.gender,
    this.phoneNumber,
    this.countryCode,
    this.role,
    this.accessLevels,
    this.shiftTiming,
    this.firstName,
    this.lastName,
    this.countryIsoCode,
    this.leaves,
    this.agencyId,
  }) {
    accessLevels ??= AccessLevels(
      viewBookings: false,
      createBookings: false,
      editBookings: false,
      viewEmployees: false,
      createEmployees: false,
      editEmployees: false,
      personalProfileEdit: false,
      personalAttendanceReport: false,
      attendanceReport: false,
      weatherReport: false,
      editActivityPrices: false,
      addActivity: false,
      notifications: false,
      boatPlan: false,
      marketingGallery: false,
      offers: false,
    );
  }

  String id;
  String? gender;
  String? phoneNumber;
  String? countryCode;
  String? role;
  AccessLevels? accessLevels;
  DateTime? shiftTiming;
  String? firstName;
  String? lastName;
  String? countryIsoCode;
  String? agencyId;
  List<Timestamp>? leaves;

  @override
  int get hashCode =>
      id.hashCode ^
      gender.hashCode ^
      phoneNumber.hashCode ^
      countryCode.hashCode ^
      role.hashCode ^
      accessLevels.hashCode ^
      shiftTiming.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      countryIsoCode.hashCode ^
      leaves.hashCode ^
      agencyId.hashCode;

  @override
  bool operator ==(Object other) {
    if ((other is Employee || other is Instructor)) {
      if (other is Instructor) {
        return id == other.id;
      }
      if (other is Employee) {
        return id == other.id;
      }
    }
    return false;
  }

  factory Employee.fromMap(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      countryIsoCode: json['countryIsoCode'],
      role: json['role'],
      accessLevels: AccessLevels.fromMap(json['accessLevels']),
      shiftTiming: DateTime(
        2021,
        1,
        1,
        int.parse(json['shiftTiming'].split(':')[0]),
        int.parse(json['shiftTiming'].split(':')[0]),
        int.parse(json['shiftTiming'].split(':')[0]),
      ),
      firstName: json['firstName'],
      lastName: json['lastName'],
      agencyId: json['agencyId'],
      leaves: List<Timestamp>.from((json['leaves'] ?? []).map((x) => (x))),
    );
  }

  String get name => '${firstName!} ${lastName ?? ''}';

  get authPhone => countryCode! + phoneNumber!;

  Map<String, dynamic> toMap() => {
        'id': id,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
        'countryIsoCode': countryIsoCode,
        'role': role,
        'accessLevels': accessLevels!.toMap(),
        'shiftTiming': '${shiftTiming!.hour}:${shiftTiming!.minute}:${shiftTiming!.second}',
        'firstName': firstName,
        'lastName': lastName,
        'agencyId': agencyId,
        'leaves': List<Timestamp>.from((leaves ?? []).map((x) => (x))),
      };
}

class AccessLevels {
  AccessLevels({
    required this.viewBookings,
    required this.createBookings,
    required this.editBookings,
    required this.viewEmployees,
    required this.createEmployees,
    required this.editEmployees,
    required this.personalProfileEdit,
    required this.personalAttendanceReport,
    required this.attendanceReport,
    required this.weatherReport,
    required this.editActivityPrices,
    required this.addActivity,
    required this.notifications,
    required this.boatPlan,
    required this.marketingGallery,
    required this.offers,
  });

  bool? viewBookings;
  bool? createBookings;
  bool? editBookings;
  bool? viewEmployees;
  bool? createEmployees;
  bool? editEmployees;
  bool? personalProfileEdit;
  bool? personalAttendanceReport;
  bool? attendanceReport;
  bool? weatherReport;
  bool? editActivityPrices;
  bool? addActivity;
  bool? notifications;
  bool? boatPlan;
  bool? marketingGallery;
  bool? offers;

  factory AccessLevels.fromMap(Map<String, dynamic> json) => AccessLevels(
        viewBookings: json['viewBookings'],
        boatPlan: json['boatPlan'],
        createBookings: json['createBookings'],
        editBookings: json['editBookings'],
        viewEmployees: json['viewEmployees'],
        createEmployees: json['createEmployees'],
        editEmployees: json['editEmployees'],
        personalProfileEdit: json['personalProfileEdit'],
        personalAttendanceReport: json['personalAttendanceReport'],
        attendanceReport: json['attendanceReport'],
        weatherReport: json['weatherReport'],
        editActivityPrices: json['editActivityPrices'],
        addActivity: json['addActivity'],
        notifications: json['notifications'],
        marketingGallery: json['marketingGallery'],
        offers: json['offers'],
      );

  Map<String, dynamic> toMap() => {
        'viewBookings': viewBookings,
        'boatPlan': boatPlan,
        'createBookings': createBookings,
        'editBookings': editBookings,
        'viewEmployees': viewEmployees,
        'createEmployees': createEmployees,
        'editEmployees': editEmployees,
        'personalProfileEdit': personalProfileEdit,
        'personalAttendanceReport': personalAttendanceReport,
        'attendanceReport': attendanceReport,
        'weatherReport': weatherReport,
        'editActivityPrices': editActivityPrices,
        'addActivity': addActivity,
        'notifications': notifications,
        'marketingGallery': marketingGallery,
        'offers': offers,
      };
}

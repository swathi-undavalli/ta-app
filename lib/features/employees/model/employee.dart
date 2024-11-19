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
    this.accessLevels = const AccessLevels(
      viewBookings: false,
      createBookings: false,
      editBookings: false,
      viewEmployees: false,
      createEmployees: false,
      editEmployees: false,
      personalProfileEdit: false,
      weatherReport: false,
      editActivityPrices: false,
      addActivity: false,
      notifications: false,
      boatPlan: false,
      marketingGallery: false,
      offers: false,
      processCertificate: false,
      addEquipment: false,
      viewEquipment: false,
    ),
    this.firstName,
    this.lastName,
    this.nickName,
    this.countryIsoCode,
    this.leaves,
    this.agencyId,
  });

  final String id;
  final String? gender;
  final String? phoneNumber;
  final String? countryCode;
  final String? role;
  final AccessLevels? accessLevels;
  final String? firstName;
  final String? lastName;
  final String? nickName;
  final String? countryIsoCode;
  final String? agencyId;
  final List<Timestamp>? leaves;

  @override
  int get hashCode =>
      id.hashCode ^
      gender.hashCode ^
      phoneNumber.hashCode ^
      countryCode.hashCode ^
      role.hashCode ^
      accessLevels.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      nickName.hashCode ^
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
      firstName: json['firstName'],
      lastName: json['lastName'],
      nickName: json['nickName'],
      agencyId: json['agencyId'],
      leaves: List<Timestamp>.from((json['leaves'] ?? []).map((x) => (x))),
    );
  }

  String get name =>
      '${firstName!} ${(nickName != null && nickName!.isNotEmpty) ? '"$nickName" ' : ""}${lastName ?? ''}';

  get authPhone => countryCode! + phoneNumber!;

  Map<String, dynamic> toMap() => {
        'id': id,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
        'countryIsoCode': countryIsoCode,
        'role': role,
        'accessLevels': accessLevels!.toMap(),
        'firstName': firstName,
        'lastName': lastName,
        'nickName': nickName,
        'agencyId': agencyId,
        'leaves': List<Timestamp>.from((leaves ?? []).map((x) => (x))),
      };

  Employee copyWith({
    String? firstName,
    String? lastName,
    String? countryIsoCode,
    String? countryCode,
    String? phoneNumber,
    AccessLevels? accessLevels,
    List<Timestamp>? leaves,
  }) {
    return Employee(
      id: id,
      gender: gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      role: role,
      accessLevels: accessLevels ?? this.accessLevels,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickName: nickName,
      countryIsoCode: countryIsoCode ?? this.countryIsoCode,
      leaves: leaves ?? this.leaves,
      agencyId: agencyId,
    );
  }

  bool isOnLeave(DateTime now) {
    if ((leaves ?? []).isEmpty) {
      return false;
    }

    DateTime startDate = (leaves![0].toDate());
    DateTime endDate = (leaves![1].toDate()).add(const Duration(days: 1));

    return now.isAfter(startDate) && now.isBefore(endDate) ||
        now.isAtSameMomentAs(startDate) ||
        now.isAtSameMomentAs(endDate);
  }
}

class AccessLevels {
  const AccessLevels({
    required this.viewBookings,
    required this.createBookings,
    required this.editBookings,
    required this.viewEmployees,
    required this.createEmployees,
    required this.editEmployees,
    required this.personalProfileEdit,
    required this.weatherReport,
    required this.editActivityPrices,
    required this.addActivity,
    required this.notifications,
    required this.boatPlan,
    required this.marketingGallery,
    required this.offers,
    required this.processCertificate,
    required this.addEquipment,
    required this.viewEquipment,
  });

  final bool? viewBookings;
  final bool? createBookings;
  final bool? editBookings;
  final bool? viewEmployees;
  final bool? createEmployees;
  final bool? editEmployees;
  final bool? personalProfileEdit;
  final bool? weatherReport;
  final bool? editActivityPrices;
  final bool? addActivity;
  final bool? notifications;
  final bool? boatPlan;
  final bool? marketingGallery;
  final bool? offers;
  final bool? processCertificate;
  final bool? addEquipment;
  final bool? viewEquipment;

  factory AccessLevels.fromMap(Map<String, dynamic> json) => AccessLevels(
        viewBookings: json['viewBookings'],
        boatPlan: json['boatPlan'],
        createBookings: json['createBookings'],
        editBookings: json['editBookings'],
        viewEmployees: json['viewEmployees'],
        createEmployees: json['createEmployees'],
        editEmployees: json['editEmployees'],
        personalProfileEdit: json['personalProfileEdit'],
        weatherReport: json['weatherReport'],
        editActivityPrices: json['editActivityPrices'],
        addActivity: json['addActivity'],
        notifications: json['notifications'],
        marketingGallery: json['marketingGallery'],
        offers: json['offers'],
        processCertificate: json['processCertificate'],
        addEquipment: json['addEquipment'],
        viewEquipment: json['viewEquipment'],
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
        'weatherReport': weatherReport,
        'editActivityPrices': editActivityPrices,
        'addActivity': addActivity,
        'notifications': notifications,
        'marketingGallery': marketingGallery,
        'offers': offers,
        'processCertificate': processCertificate,
        'viewEquipment': viewEquipment,
        'addEquipment': addEquipment,
      };
}

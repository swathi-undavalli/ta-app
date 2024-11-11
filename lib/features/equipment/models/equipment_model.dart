import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'equipment_model.mapper.dart';

@immutable
@MappableClass()
class EquipmentItem with EquipmentItemMappable {
  final EquipmentCategory category;
  final String name;
  final String id;
  final String photo;

  EquipmentItem({
    required this.category,
    required this.name,
    required this.id,
    required this.photo,
  });
}

@immutable
@MappableClass()
class EquipmentCategory with EquipmentCategoryMappable {
  final String name;
  final String id;

  const EquipmentCategory({
    required this.name,
    required this.id,
  });
}

@immutable
@MappableClass()
class EquipmentPiece with EquipmentPieceMappable {
  final String id;
  final String equipmentName;
  final String equipmentId;
  final String? currentRental;
  final Timestamp? lastRented;

  const EquipmentPiece({
    required this.id,
    required this.equipmentName,
    required this.equipmentId,
    required this.currentRental,
    required this.lastRented,
  });
}

@immutable
@MappableClass()
class EquipmentRentals with EquipmentRentalsMappable {
  final String id;
  final String equipmentId;
  final String rentedBy;
  final String issuedBy;
  final Timestamp dateOut;
  final Timestamp? dateIn;
  final String dayCourses;

  const EquipmentRentals({
    required this.id,
    required this.equipmentId,
    required this.rentedBy,
    required this.issuedBy,
    required this.dateOut,
    required this.dateIn,
    required this.dayCourses,
  });
}

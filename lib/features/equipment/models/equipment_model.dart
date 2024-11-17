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
  final String? photo;

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
  final String assignedID;
  final String equipmentItemID;
  final String equipmentItemName;
  final String? currentRental;
  final Timestamp? lastRented;

  const EquipmentPiece({
    required this.id,
    required this.assignedID,
    required this.equipmentItemID,
    required this.equipmentItemName,
    required this.currentRental,
    required this.lastRented,
  });
}
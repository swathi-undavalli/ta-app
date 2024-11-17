import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'equipment_model.dart';

part 'equipment_log_model.mapper.dart';

@immutable
@MappableClass()
class EquipmentLog with EquipmentLogMappable {
  final String id;
  final String approverID;
  final String renterID;
  final String? collectorID;
  final String notes;
  final List<EquipmentPiece> pieces;
  final Timestamp time;
  final Timestamp collectedTime;

  EquipmentLog({
    required this.renterID,
    required this.approverID,
    this.collectorID,
    required this.id,
    required this.pieces,
    required this.notes,
    required this.time,
    required this.collectedTime,
  });
}

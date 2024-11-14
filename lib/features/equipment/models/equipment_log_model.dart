import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'equipment_model.dart';

part 'equipment_log_model.mapper.dart';

@immutable
@MappableClass()
class EquipmentLog with EquipmentLogMappable {
  final String renterID;
  final String id;
  final String approverID;
  final String notes;
  final List<EquipmentPiece> pieces;
  final Timestamp time;

  const EquipmentLog({
    required this.renterID,
    required this.approverID,
    required this.id,
    required this.pieces,
    required this.notes,
    required this.time,
  });
}

// Added handle firebase objects safely.
class TimestampMapper extends SimpleMapper<Timestamp> {
  @override
  dynamic encode(Timestamp self) => self; // Return Timestamp directly

  @override
  Timestamp decode(dynamic value) {
    if (value is Timestamp) {
      return value; // If it's already a Timestamp, return it
    } else if (value is int) {
      // Optionally, handle integer-based timestamp (e.g., milliseconds since epoch)
      return Timestamp.fromMillisecondsSinceEpoch(value);
    } else {
      throw Exception('Cannot decode $value to Timestamp');
    }
  }
}

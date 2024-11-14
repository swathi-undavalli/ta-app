import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'equipment_model.dart';

part 'otp_validation_model.mapper.dart';

@immutable
@MappableClass()
class OtpValidation with OtpValidationMappable {
  final String? renterID;
  final String? approverID;
  final String otp;
  final bool approve;
  final List<EquipmentPiece> pieces;

  OtpValidation({
    required this.renterID,
    required this.approverID,
    required this.otp,
    required this.approve,
    required this.pieces,
  });
}

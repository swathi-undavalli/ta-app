import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class DiveSiteModel {
  final String? id;
  final String name;
  final GeoPoint latLang;

  const DiveSiteModel({
    this.id,
    required this.name,
    required this.latLang,
  });

  /// Convert model to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lat_lang': latLang,
    };
  }

  /// Create model from a Map<String, dynamic>
  factory DiveSiteModel.fromMap(Map<String, dynamic> map) {
    return DiveSiteModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      latLang: map['lat_lang'] as GeoPoint,
    );
  }

  /// Create a new copy of this model with updated fields
  DiveSiteModel copyWith({
    String? id,
    String? name,
    GeoPoint? latLang,
  }) {
    return DiveSiteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latLang: latLang ?? this.latLang,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiveSiteModel &&
          runtimeType == other.runtimeType &&
          id != null &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

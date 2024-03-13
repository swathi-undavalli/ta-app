import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class Offer {
  final String? categoryId;
  final String id;
  final String name;
  final List<Timestamp>? validDates;
  final String? description;
  final List<String>? photos;
  final String? createdBy;

  Offer({
    required this.categoryId,
    required this.id,
    required this.name,
    required this.validDates,
    required this.description,
    required this.photos,
    required this.createdBy,
  });

  Offer copyWith({
    String? categoryId,
    String? id,
    String? name,
    List<Timestamp>? validDates,
    String? description,
    String? createdBy,
    List<String>? photos,
  }) =>
      Offer(
        categoryId: categoryId ?? this.categoryId,
        id: id ?? this.id,
        name: name ?? this.name,
        validDates: validDates ?? this.validDates,
        description: description ?? this.description,
        photos: photos ?? this.photos,
        createdBy: createdBy ?? this.createdBy,
      );

  factory Offer.fromRawJson(String str) => Offer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        categoryId: json['categoryId'],
        id: json['id'],
        name: json['name'],
        validDates: List<Timestamp>.from((json['validDates'] ?? []).map((x) => x)),
        description: json['description'],
        createdBy: json['createdBy'],
        photos: List<String>.from((json['photos'] ?? []).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'id': id,
        'name': name,
        'validDates': List<Timestamp>.from((validDates ?? []).map((x) => x)),
        'description': description,
        'createdBy': createdBy,
        'photos': List<String>.from((photos ?? []).map((x) => x)),
      };
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final List<OfferElement>? offerElement;

  Offer({
    required this.offerElement,
  });

  Offer copyWith({
    List<OfferElement>? offer,
  }) =>
      Offer(
        offerElement: offer ?? offerElement,
      );

  factory Offer.fromRawJson(String str) => Offer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        offerElement: List<OfferElement>.from((json['offer'] ?? ([])).map((x) => OfferElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'offer': List<dynamic>.from((offerElement ?? []).map((x) => x.toJson())),
      };
}

class OfferElement {
  final String? categoryId;
  final String name;
  final List<Timestamp>? validDates;
  final String? description;
  final List<String>? photos;
  final String? createdBy;

  OfferElement({
    required this.categoryId,
    required this.name,
    required this.validDates,
    required this.description,
    required this.photos,
    required this.createdBy,
  });

  OfferElement copyWith({
    String? categoryId,
    String? name,
    List<Timestamp>? validDates,
    String? description,
    String? createdBy,
    List<String>? photos,
  }) =>
      OfferElement(
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        validDates: validDates ?? this.validDates,
        description: description ?? this.description,
        photos: photos ?? this.photos,
        createdBy: createdBy ?? this.createdBy,
      );

  factory OfferElement.fromRawJson(String str) => OfferElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfferElement.fromJson(Map<String, dynamic> json) => OfferElement(
        categoryId: json['categoryId'],
        name: json['name'],
        validDates: List<Timestamp>.from((json['validDates'] ?? []).map((x) => x)),
        description: json['description'],
        createdBy: json['createdBy'],
        photos: List<String>.from((json['photos'] ?? []).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'name': name,
        'validDates': List<Timestamp>.from((validDates ?? []).map((x) => x)),
        'description': description,
        'createdBy': createdBy,
        'photos': List<String>.from((photos ?? []).map((x) => x)),
      };
}

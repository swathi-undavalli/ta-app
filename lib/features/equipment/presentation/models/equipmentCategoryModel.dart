import 'dart:convert';

class EquipmentCategoryModel {
  final String categoryName;
  final String id;

  EquipmentCategoryModel({
    required this.categoryName,
    required this.id,
  });

  EquipmentCategoryModel copyWith({
    String? categoryName,
    String? id,
  }) =>
      EquipmentCategoryModel(
        categoryName: categoryName ?? this.categoryName,
        id: id ?? this.id,
      );

  factory EquipmentCategoryModel.fromRawJson(String str) => EquipmentCategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EquipmentCategoryModel.fromJson(Map<String, dynamic> json) => EquipmentCategoryModel(
        categoryName: json['categoryName'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'id': id,
      };
}

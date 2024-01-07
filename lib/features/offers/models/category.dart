import 'dart:convert';

class Categories {
  final String name;
  final String id;

  Categories({
    required this.name,
    required this.id,
  });

  Categories copyWith({
    String? name,
    String? id,
  }) =>
      Categories(
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory Categories.fromRawJson(String str) => Categories.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory Categories.fromMap(Map<String, dynamic> json) => Categories(
        name: json['name'],
        id: json['id'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };

}

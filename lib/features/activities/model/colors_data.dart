import 'dart:convert';

ColorsDataModel? colorsData;

class ColorsDataModel {
  ColorsDataModel({
    required this.blue,
    required this.green,
    required this.red,
    required this.white,
    required this.purple,
  });

  final List<String> blue;
  final List<String> green;
  final List<String> red;
  final List<String> white;
  final List<String> purple;

  ColorsDataModel copyWith({
    List<String>? blue,
    List<String>? green,
    List<String>? red,
    List<String>? white,
    List<String>? purple,
  }) =>
      ColorsDataModel(
        blue: blue ?? this.blue,
        green: green ?? this.green,
        red: red ?? this.red,
        white: white ?? this.white,
        purple: purple ?? this.purple,
      );

  factory ColorsDataModel.fromJson(String str) => ColorsDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ColorsDataModel.fromMap(Map<String, dynamic> json) => ColorsDataModel(
    blue: List<String>.from(json['Blue'].map((x) => x)),
    green: List<String>.from(json['Green'].map((x) => x)),
    red: List<String>.from(json['Red'].map((x) => x)),
    white: List<String>.from(json['White'].map((x) => x)),
    purple: List<String>.from(json['Purple'].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    'Blue': List<dynamic>.from(blue.map((x) => x)),
    'Green': List<dynamic>.from(green.map((x) => x)),
    'Red': List<dynamic>.from(red.map((x) => x)),
    'White': List<dynamic>.from(white.map((x) => x)),
    'Purple': List<dynamic>.from(purple.map((x) => x)),
  };
}

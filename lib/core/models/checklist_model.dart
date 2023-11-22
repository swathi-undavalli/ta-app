import 'dart:convert';

class Checklist {
  final List<ChecklistElement>? checklistElement;

  Checklist({
    required this.checklistElement,
  });

  Checklist copyWith({
    List<ChecklistElement>? checklist,
  }) =>
      Checklist(
        checklistElement: checklist ?? checklistElement,
      );

  factory Checklist.fromRawJson(String str) =>
      Checklist.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory Checklist.fromMap(Map<String, dynamic>? json) => Checklist(
        checklistElement: List<ChecklistElement>.from(
          (json?['checklist'] ?? ([])).map((x) => ChecklistElement.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        'checklist':
            List<dynamic>.from((checklistElement ?? []).map((x) => x.toMap())),
      };
}

class ChecklistElement {
  final List<Item> items;
  final String? employeeId;
  final String id;
  final String title;
  final String description;

  ChecklistElement({
    required this.items,
    required this.employeeId,
    required this.id,
    required this.title,
    required this.description,
  });

  ChecklistElement copyWith({
    List<Item>? items,
    String? employeeId,
    String? id,
    String? title,
    String? description,
  }) =>
      ChecklistElement(
        items: items ?? this.items,
        employeeId: employeeId ?? this.employeeId,
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  factory ChecklistElement.fromRawJson(String str) =>
      ChecklistElement.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory ChecklistElement.fromMap(Map<String, dynamic> json) =>
      ChecklistElement(
        items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
        employeeId: json['employeeId'],
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() => {
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
        'employeeId': employeeId,
        'id': id,
        'title': title,
        'description': description,
      };
}

class Item {
  final String name;
  bool isChecked;

  Item({
    required this.name,
    required this.isChecked,
  });

  Item copyWith({
    String? name,
    bool? isChecked,
  }) =>
      Item(
        name: name ?? this.name,
        isChecked: isChecked ?? this.isChecked,
      );

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json['name'],
        isChecked: json['isChecked'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'isChecked': isChecked,
      };
}

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
  final List<String> items;
  final String? employeeId;
  final String id;
  final String name;
  final String description;

  ChecklistElement({
    required this.items,
    required this.employeeId,
    required this.id,
    required this.name,
    required this.description,
  });

  ChecklistElement copyWith({
    List<String>? items,
    String? employeeId,
    String? id,
    String? name,
    String? description,
  }) =>
      ChecklistElement(
        items: items ?? this.items,
        employeeId: employeeId ?? this.employeeId,
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory ChecklistElement.fromRawJson(String str) =>
      ChecklistElement.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory ChecklistElement.fromMap(Map<String, dynamic> json) =>
      ChecklistElement(
        items: List<String>.from(json['items'].map((x) => x)),
        employeeId: json['employeeId'],
        id: json['id'],
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() => {
        'items': List<dynamic>.from(items.map((x) => x)),
        'employeeId': employeeId,
        'id': id,
        'name': name,
        'description': description,
      };
}

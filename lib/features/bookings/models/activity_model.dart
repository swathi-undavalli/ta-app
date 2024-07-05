class Activity {
  Activity({
    this.name,
    this.shortName,
    this.price,
    this.id,
    this.priority,
    this.color,
  });

  final String? name;
  final String? shortName;
  final int? price;
  final String? id;
  final int? priority;
  final String? color;

  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        name: json['name'],
        shortName: json['shortName'],
        price: json['price'],
        priority: json['priority'],
        id: json['id'],
        color: json['color'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'shortName': shortName,
        'price': price,
        'priority': priority,
        'id': id,
        'color': color,
      };

  Activity copyWith({
    String? name,
    String? shortName,
    int? price,
    String? id,
    int? priority,
    String? color,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      price: price ?? this.price,
      priority: priority ?? this.priority,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(dynamic other) {
    return other != null && other is Activity && name == other.name;
  }

  @override
  int get hashCode => super.hashCode ^ name.hashCode;
}

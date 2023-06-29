class ActivityModel {
  ActivityModel(
      {this.name,
      this.shortName,
      this.price,
      this.id,
      this.priority,
      this.color});

  String? name;
  String? shortName;
  int? price;
  String? id;
  int? priority;
  String? color;

  factory ActivityModel.fromMap(Map<String, dynamic> json) => ActivityModel(
        name: json["name"],
        shortName: json["shortName"],
        price: json["price"],
        priority: json["priority"],
        id: json["id"],
        color: json["color"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "shortName": shortName,
        "price": price,
        "priority": priority,
        "id": id,
        "color": color,
      };

  bool operator ==(dynamic other) {
    return other != null && other is ActivityModel && this.name == other.name;
  }

  @override
  int get hashCode => super.hashCode;
}

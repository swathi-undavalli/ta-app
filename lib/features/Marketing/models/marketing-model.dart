class Marketing {
  final List<MarketingElement>? marketingElement;

  Marketing({
    required this.marketingElement,
  });

  Marketing copyWith({
    List<MarketingElement>? marketing,
  }) =>
      Marketing(
        marketingElement: marketing ?? this.marketingElement,
      );

  factory Marketing.fromJson(Map<String, dynamic> json) => Marketing(
        marketingElement:
            List<MarketingElement>.from((json["marketing"] ?? ([])).map((x) => MarketingElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "marketing": List<dynamic>.from((marketingElement ?? []).map((x) => x.toJson())),
      };
}

class MarketingElement {
  final String? name;
  final String url;
  final String type;
  final int duration;
  final String? createdBy;

  MarketingElement({
    required this.name,
    required this.url,
    required this.type,
    required this.duration,
    required this.createdBy,
  });

  MarketingElement copyWith({
    String? name,
    String? url,
    String? type,
    String? createdBy,
    int? duration,
  }) =>
      MarketingElement(
        name: name ?? this.name,
        url: url ?? this.url,
        type: type ?? this.type,
        createdBy: createdBy ?? this.createdBy,
        duration: duration ?? this.duration,
      );

  factory MarketingElement.fromJson(Map<String, dynamic> json) => MarketingElement(
        name: json["name"],
        url: json["url"],
        type: json["type"],
        createdBy: json["createdBy"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "type": type,
        "createdBy": createdBy,
        "duration": duration,
      };
}

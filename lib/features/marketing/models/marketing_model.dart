class Marketing {
  final List<MarketingElement>? marketingElements;

  Marketing({
    required this.marketingElements,
  });

  Marketing copyWith({
    List<MarketingElement>? marketing,
  }) =>
      Marketing(
        marketingElements: marketing ?? marketingElements,
      );

  factory Marketing.fromJson(Map<String, dynamic> json) => Marketing(
        marketingElements:
            List<MarketingElement>.from((json['marketing'] ?? ([])).map((x) => MarketingElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'marketing': List<dynamic>.from((marketingElements ?? []).map((x) => x.toJson())),
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
        name: json['name'],
        url: json['url'],
        type: json['type'],
        duration: json['duration'],
        createdBy: json['createdBy'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'type': type,
        'duration': duration,
        'createdBy': createdBy,
      };
}

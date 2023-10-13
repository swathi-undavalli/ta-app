class Marketing {
  final List<MarketingElement>? marketingGallery;

  Marketing({
    required this.marketingGallery,
  });

  Marketing copyWith({
    List<MarketingElement>? marketing,
  }) =>
      Marketing(
        marketingGallery: marketing ?? marketingGallery,
      );

  factory Marketing.fromJson(Map<String, dynamic> json) => Marketing(
        marketingGallery:
            List<MarketingElement>.from((json['marketing'] ?? ([])).map((x) => MarketingElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'marketing': List<dynamic>.from((marketingGallery ?? []).map((x) => x.toJson())),
      };
}

class MarketingElement {
  final String? name;
  final String url;
  final String type;
  final int duration;

  MarketingElement({
    required this.name,
    required this.url,
    required this.type,
    required this.duration,
  });

  MarketingElement copyWith({
    String? name,
    String? url,
    String? type,
    int? duration,
  }) =>
      MarketingElement(
        name: name ?? this.name,
        url: url ?? this.url,
        type: type ?? this.type,
        duration: duration ?? this.duration,
      );

  factory MarketingElement.fromJson(Map<String, dynamic> json) => MarketingElement(
        name: json['name'],
        url: json['url'],
        type: json['type'],
        duration: json['duration'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'type': type,
        'duration': duration,
      };
}

class Marketing {
  final List<MarketingElement>? marketingGallery;

  Marketing({
    required this.marketingGallery,
  });

  Marketing copyWith({
    List<MarketingElement>? marketing,
  }) =>
      Marketing(
        marketingGallery: marketing ?? this.marketingGallery,
      );

  factory Marketing.fromJson(Map<String, dynamic> json) => Marketing(
        marketingGallery:
            List<MarketingElement>.from((json["marketing"] ?? ([])).map((x) => MarketingElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "marketing": List<dynamic>.from((marketingGallery ?? []).map((x) => x.toJson())),
      };
}

class MarketingElement {
  final String? name;
  final String url;
  final String type;
  final int? delay;

  MarketingElement({
    required this.name,
    required this.url,
    required this.type,
    required this.delay,
  });

  MarketingElement copyWith({
    String? name,
    String? url,
    String? type,
    int? delay,
  }) =>
      MarketingElement(
        name: name ?? this.name,
        url: url ?? this.url,
        type: type ?? this.type,
        delay: delay ?? this.delay,
      );

  factory MarketingElement.fromJson(Map<String, dynamic> json) => MarketingElement(
        name: json["name"],
        url: json["url"],
        type: json["type"],
        delay: json["delay"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "type": type,
        "delay": delay,
      };
}

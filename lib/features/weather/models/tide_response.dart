import 'dart:convert';

TideResponse tideResponseFromMap(String str) =>
    TideResponse.fromMap(json.decode(str));

String tideResponseToMap(TideResponse data) => json.encode(data.toMap());

class TideResponse {
  TideResponse({
    this.extremes,
  });

  List<Extreme>? extremes;

  factory TideResponse.fromMap(Map<String, dynamic> json) {
    print(json);
    return TideResponse(
      extremes: List<Extreme>.from(json["data"].map((x) => Extreme.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(extremes!.map((x) => x.toMap())),
      };
}

class Extreme {
  Extreme({
    this.datetime,
    this.height,
    this.state,
  });

  DateTime? datetime;
  double? height;
  String? state;

  factory Extreme.fromMap(Map<String, dynamic> json) {
    print("are mawa");
    print(json.toString());
    return Extreme(
      datetime: DateTime.parse(json["datetime"]),
      height: json["height"].toDouble(),
      state: json["type"],
    );
  }

  Map<String, dynamic> toMap() => {
        "datetime": datetime!.toIso8601String(),
        "height": height,
        "type": state,
      };
}

import 'dart:convert';

TideResponse tideResponseFromMap(String str) =>
    TideResponse.fromMap(json.decode(str));

String tideResponseToMap(TideResponse data) => json.encode(data.toMap());

class TideResponse {
  TideResponse({
    // this.disclaimer,
    // this.status,
    // this.latitude,
    // this.longitude,
    // this.origin,
    // this.datums,
    // this.timestamp,
    // this.datetime,
    // this.unit,
    // this.timezone,
    // this.datum,
    this.extremes,
    // this.heights,
  });

  // String disclaimer;
  // int status;
  // double latitude;
  // double longitude;
  // Origin origin;
  // Datums datums;
  // int timestamp;
  // DateTime datetime;
  // String unit;
  // String timezone;
  // String datum;
  List<Extreme>? extremes;
  // List<Extreme> heights;

  factory TideResponse.fromMap(Map<String, dynamic> json) {
    //print(json);
    return TideResponse(
      // disclaimer: json["disclaimer"],
      // status: json["status"],
      // latitude: json["latitude"].toDouble(),
      // longitude: json["longitude"].toDouble(),
      // origin: Origin.fromMap(json["origin"]),
      // datums: Datums.fromMap(json["datums"]),
      // timestamp: json["timestamp"],
      // datetime: DateTime.parse(json["datetime"]),
      // unit: json["unit"],
      // timezone: json["timezone"],
      // datum: json["datum"],
      extremes:
          List<Extreme>.from(json["extremes"].map((x) => Extreme.fromMap(x))),
      // heights:
      //     List<Extreme>.from(json["heights"].map((x) => Extreme.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        // "disclaimer": disclaimer,
        // "status": status,
        // "latitude": latitude,
        // "longitude": longitude,
        // "origin": origin.toMap(),
        // "datums": datums.toMap(),
        // "timestamp": timestamp,
        // "datetime": datetime.toIso8601String(),
        // "unit": unit,
        // "timezone": timezone,
        // "datum": datum,
        "extremes": List<dynamic>.from(extremes!.map((x) => x.toMap())),
        // "heights": List<dynamic>.from(heights.map((x) => x.toMap())),
      };
}

class Datums {
  Datums({
    this.lat,
    this.hat,
  });

  double? lat;
  double? hat;

  factory Datums.fromMap(Map<String, dynamic> json) => Datums(
        lat: json["LAT"].toDouble(),
        hat: json["HAT"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "LAT": lat,
        "HAT": hat,
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
  State? state;

  factory Extreme.fromMap(Map<String, dynamic> json) => Extreme(
        datetime: DateTime.parse(json["datetime"]),
        height: json["height"].toDouble(),
        state: stateValues.map[json["state"]],
      );

  Map<String, dynamic> toMap() => {
        "datetime": datetime!.toIso8601String(),
        "height": height,
        "state": stateValues.reverse![state],
      };
}

enum State { HIGH_TIDE, LOW_TIDE, RISING, FALLING }

final stateValues = EnumValues({
  "FALLING": State.FALLING,
  "HIGH TIDE": State.HIGH_TIDE,
  "LOW TIDE": State.LOW_TIDE,
  "RISING": State.RISING
});

class Origin {
  Origin({
    this.latitude,
    this.longitude,
    this.distance,
    this.unit,
  });

  double? latitude;
  double? longitude;
  double? distance;
  String? unit;

  factory Origin.fromMap(Map<String, dynamic> json) => Origin(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        distance: json["distance"].toDouble(),
        unit: json["unit"],
      );

  Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "unit": unit,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

import 'dart:convert';

List<WeatherResponse> weatherResponseFromMap(String str) =>
    List<WeatherResponse>.from(
        json.decode(str).map((x) => WeatherResponse.fromMap(x)));

String weatherResponseToMap(List<WeatherResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class WeatherResponse {
  WeatherResponse({
    this.timestamp,
    this.localTimestamp,
    this.issueTimestamp,
    this.fadedRating,
    this.solidRating,
    this.swell,
    this.wind,
    this.condition,
    this.charts,
  });

  int timestamp;
  int localTimestamp;
  int issueTimestamp;
  double fadedRating;
  double solidRating;
  Swell swell;
  Wind wind;
  Condition condition;
  Charts charts;

  factory WeatherResponse.fromMap(Map<String, dynamic> json) {
    try {
      return WeatherResponse(
        timestamp: json["timestamp"],
        localTimestamp: json["localTimestamp"],
        issueTimestamp: json["issueTimestamp"],
        fadedRating: json["fadedRating"],
        solidRating: json["solidRating"],
        swell: Swell.fromMap(json["swell"]),
        wind: Wind.fromMap(json["wind"]),
        condition: Condition.fromMap(json["condition"]),
        charts: Charts.fromMap(json["charts"]),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Map<String, dynamic> toMap() => {
        "timestamp": timestamp,
        "localTimestamp": localTimestamp,
        "issueTimestamp": issueTimestamp,
        "fadedRating": fadedRating,
        "solidRating": solidRating,
        "swell": swell.toMap(),
        "wind": wind.toMap(),
        "condition": condition.toMap(),
        "charts": charts.toMap(),
      };
}

class Charts {
  Charts({
    this.swell,
    this.period,
    this.wind,
    this.pressure,
    this.sst,
  });

  String swell;
  String period;
  String wind;
  String pressure;
  String sst;

  factory Charts.fromMap(Map<String, dynamic> json) => Charts(
        swell: json["swell"],
        period: json["period"],
        wind: json["wind"],
        pressure: json["pressure"],
        sst: json["sst"],
      );

  Map<String, dynamic> toMap() => {
        "swell": swell,
        "period": period,
        "wind": wind,
        "pressure": pressure,
        "sst": sst,
      };
}

class Condition {
  Condition({
    this.pressure,
    this.temperature,
    this.unitPressure,
    this.unit,
  });

  double pressure;
  double temperature;
  String unitPressure;
  String unit;

  factory Condition.fromMap(Map<String, dynamic> json) => Condition(
        pressure: json["pressure"],
        temperature: json["temperature"],
        unitPressure: json["unitPressure"],
        unit: json["unit"],
      );

  Map<String, dynamic> toMap() => {
        "pressure": pressure,
        "temperature": temperature,
        "unitPressure": unitPressure,
        "unit": unit,
      };
}

class Swell {
  Swell({
    this.minBreakingHeight,
    this.absMinBreakingHeight,
    this.maxBreakingHeight,
    this.absMaxBreakingHeight,
    this.unit,
    this.components,
  });

  double minBreakingHeight;
  double absMinBreakingHeight;
  double maxBreakingHeight;
  double absMaxBreakingHeight;
  String unit;
  Components components;

  factory Swell.fromMap(Map<String, dynamic> json) {
    try {
      return Swell(
        minBreakingHeight: json["minBreakingHeight"],
        absMinBreakingHeight: json["absMinBreakingHeight"].toDouble(),
        maxBreakingHeight: json["maxBreakingHeight"],
        absMaxBreakingHeight: json["absMaxBreakingHeight"].toDouble(),
        unit: json["unit"],
        components: Components.fromMap(json["components"]),
      );
    } catch (e) {
      print("black sheep");
      print(e);
      return null;
    }
  }

  Map<String, dynamic> toMap() => {
        "minBreakingHeight": minBreakingHeight,
        "absMinBreakingHeight": absMinBreakingHeight,
        "maxBreakingHeight": maxBreakingHeight,
        "absMaxBreakingHeight": absMaxBreakingHeight,
        "unit": unit,
        "components": components.toMap(),
      };
}

class Components {
  Components({
    this.combined,
    this.primary,
    this.secondary,
    this.tertiary,
  });

  Combined combined;
  Combined primary;
  Combined secondary;
  Combined tertiary;

  factory Components.fromMap(Map<String, dynamic> json) {
    try {
      return Components(
        combined: Combined.fromMap(json["combined"]),
        primary: Combined.fromMap(json["primary"]),
        secondary: Combined.fromMap(json["secondary"]),
        tertiary: Combined.fromMap(json["tertiary"]),
      );
    } catch (e) {
      print("Red sheep");
      return null;
    }
  }

  Map<String, dynamic> toMap() => {
        "combined": combined.toMap(),
        "primary": primary.toMap(),
        "secondary": secondary.toMap(),
        "tertiary": tertiary.toMap(),
      };
}

class Combined {
  Combined({
    this.height,
    this.period,
    this.direction,
    this.compassDirection,
  });

  double height;
  double period;
  double direction;
  String compassDirection;

  factory Combined.fromMap(Map<String, dynamic> json) => Combined(
        height: json["height"].toDouble(),
        period: json["period"],
        direction: json["direction"].toDouble(),
        compassDirection: json["compassDirection"],
      );

  Map<String, dynamic> toMap() => {
        "height": height,
        "period": period,
        "direction": direction,
        "compassDirection": compassDirection,
      };
}

class Wind {
  Wind({
    this.speed,
    this.direction,
    this.compassDirection,
    this.chill,
    this.gusts,
    this.unit,
  });

  double speed;
  double direction;
  String compassDirection;
  double chill;
  double gusts;
  String unit;

  factory Wind.fromMap(Map<String, dynamic> json) => Wind(
        speed: json["speed"],
        direction: json["direction"],
        compassDirection: json["compassDirection"],
        chill: json["chill"],
        gusts: json["gusts"],
        unit: json["unit"],
      );

  Map<String, dynamic> toMap() => {
        "speed": speed,
        "direction": direction,
        "compassDirection": compassDirection,
        "chill": chill,
        "gusts": gusts,
        "unit": unit,
      };
}

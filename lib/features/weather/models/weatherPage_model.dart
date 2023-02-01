import 'package:meta/meta.dart';
import 'package:temple_adventures/features/weather/models/tide_response.dart';
import 'dart:convert';
import 'package:temple_adventures/features/weather/models/weather_response.dart';

WeatherPageModel weatherPageModelFromMap(String str) =>
    WeatherPageModel.fromMap(json.decode(str));

String weatherPageModelToMap(WeatherPageModel data) =>
    json.encode(data.toMap());

class WeatherPageModel {
  WeatherPageModel({
    required this.waveHeight,
    required this.heightUnits,
    required this.windSpeed,
    required this.speedUnits,
    required this.gusts,
    required this.temperature ,
    required this.tides,
    required this.temperatureUnits,
    required this.pressure,
    required this.pressureUnits,
    required this.timeStamp,
  });

  double? waveHeight;
  String? heightUnits;
  double? windSpeed;
  String? speedUnits;
  double? gusts;
  double? temperature;
  List<Extreme>? tides;
  String? temperatureUnits;
  double? pressure;
  String? pressureUnits;
  DateTime? timeStamp;

  factory WeatherPageModel.fromMap(Map<String, dynamic> json) =>
      WeatherPageModel(
        waveHeight: json["waveHeight"].toDouble(),
        heightUnits: json["heightUnits"],
        windSpeed: json["windSpeed"].toDouble(),
        speedUnits: json["speedUnits"],
        gusts: json["gusts"].toDouble(),
        temperature: json["temperature"].toDouble(),
        tides: List<Extreme>.from(json["tides"].map((x) => Extreme.fromMap(x))),
        temperatureUnits: json["temperatureUnits"],
        pressure: json["pressure"].toDouble(),
        pressureUnits: json["pressureUnits"],
        timeStamp: json["timeStamp"].toDate(),
      );

  factory WeatherPageModel.fromResponse(
      List<WeatherResponse> weatherRes, TideResponse tideRes, DateTime date) {
    double waveH = 0, waveS = 0, gusts = 0, temp = 0, press = 0, tot = 0;
    weatherRes.forEach((element) {
      //print("====");
      //print(date.day);
      // //print(DateTime.fromMillisecondsSinceEpoch(element.timestamp));
      // //print(DateTime.fromMicrosecondsSinceEpoch(element.timestamp));
      //print(DateTime.fromMillisecondsSinceEpoch(element.localTimestamp * 1000));
      // //print(DateTime.fromMillisecondsSinceEpoch(element.issueTimestamp));
      // //print(DateTime.fromMicrosecondsSinceEpoch(element.issueTimestamp));
      //print("====");
      if (date.day ==
          DateTime.fromMillisecondsSinceEpoch(element.timestamp! * 1000).day) {
        //print("Hello");
        waveH += element.swell!.components!.combined!.height!;
        waveS += element.wind!.speed!;
        gusts += element.wind!.gusts!;
        temp += element.condition!.temperature!;
        press += element.condition!.pressure!;
        tot += 1;
      }
    });

    waveH /= tot;
    waveS /= tot;
    gusts /= tot;
    temp /= tot;
    press /= tot;

    return WeatherPageModel(
      timeStamp: date,
      waveHeight: waveH,
      heightUnits: "ft",
      windSpeed: waveS,
      speedUnits: "kph",
      gusts: gusts,
      temperature: temp,
      temperatureUnits: "c",
      pressure: press,
      pressureUnits: "mb",
      tides: tideRes.extremes,
    );
  }

  Map<String, dynamic> toMap() => {
        "timeStamp": timeStamp,
        "waveHeight": waveHeight,
        "heightUnits": heightUnits,
        "windSpeed": windSpeed,
        "speedUnits": speedUnits,
        "gusts": gusts,
        "temperature": temperature,
        "tides": List<dynamic>.from(tides!.map((x) => x.toMap())),
        "temperatureUnits": temperatureUnits,
        "pressure": pressure,
        "pressureUnits": pressureUnits,
      };
}

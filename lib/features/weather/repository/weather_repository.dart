import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_adventures/core/services/api_handler.dart';
import 'package:temple_adventures/features/weather/models/tide_response.dart';
import 'package:temple_adventures/features/weather/models/weatherPage_model.dart';
import 'package:temple_adventures/features/weather/models/weather_response.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  Future<List<WeatherResponse>> getWeatherResponse() async {
    final params = {'spot_id': "957", 'units': "eu"};

    final uri = Uri.https('magicseaweed.com',
        '/api/795541b5e25309cf68f4463e88b8daa6/forecast/', params);

    final response = await http.get(uri);

    final List<dynamic> json = jsonDecode(response.body);

    List<WeatherResponse> li = [];
    json.forEach((element) {
      // //print(element);
      WeatherResponse weatherResponse = WeatherResponse.fromMap(element);
      li.add(weatherResponse);
    });
    return li;
  }

  Future<TideResponse?> getTideResponse() async {
    // var response = await API.apiHandler(
    //   url:
    //       'https://tides.p.rapidapi.com/tides?longitude=79.768021&latitude= 11.744699&interval=60&duration=1440',
    //   requestType: RequestType.Get,
    //   header: {
    //     'x-rapidapi-host': 'tides.p.rapidapi.com',
    //     'x-rapidapi-key': 'ba02214b4emshd031700e9d5d770p18df96jsn30e1ef5a3287'
    //   },
    // );
    var now = DateTime.now();
    int startDate =
        DateTime(now.year, now.month, now.day, 4).millisecondsSinceEpoch;
    int endDate = DateTime(now.year, now.month, now.day, 20)
        .add(Duration(days: 1))
        .millisecondsSinceEpoch;

    var response = await API.apiHandler(
      url:
          'https://api.stormglass.io/v2/tide/extremes/point?lat=11.744699&lng=79.768021&start=$startDate&end=$endDate',
      requestType: RequestType.Get,
      header: {
        'Authorization':
            "4c364c42-e88b-11ec-8956-0242ac130002-4c364cce-e88b-11ec-8956-0242ac130002"
      },
    );
    if (response != null) {
      final Map<String, dynamic>? json = jsonDecode(response);
      log("etetetet");

      log(json.toString());

      if (json != null) {
        TideResponse tideResponse = TideResponse.fromMap(json);
        return tideResponse;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<WeatherPageModel?> getWeatherData(DateTime date) async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("weather")
        .doc("weather")
        .get();
    if (data.data() != null && data.data()!.isNotEmpty) {
      WeatherPageModel weatherPageModel =
          WeatherPageModel.fromMap(data.data()!);

      if (DateTime.now().difference(weatherPageModel.timeStamp!).inHours >=
          12) {
        return await getLatestData(date);
      } else {
        return weatherPageModel;
      }
    } else {
      return await getLatestData(date);
    }
  }

  Future<WeatherPageModel?> getLatestData(DateTime date) async {
    List<WeatherResponse> weather = await getWeatherResponse();
    TideResponse? tide = await getTideResponse();

    if (tide != null) {
      WeatherPageModel weatherPageModel =
          WeatherPageModel.fromResponse(weather, tide, date);
      weatherPageModel.timeStamp = DateTime.now();

      FirebaseFirestore.instance
          .collection("weather")
          .doc("weather")
          .set(weatherPageModel.toMap());
      return weatherPageModel;
    } else {
      return null;
    }
  }
}

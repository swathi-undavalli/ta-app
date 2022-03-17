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

    print("=======================");
    print("started");

    final uri = Uri.https('magicseaweed.com',
        '/api/795541b5e25309cf68f4463e88b8daa6/forecast/', params);

    final response = await http.get(uri);
    log(response.body);
    print("==========================");
    print("middle");

    final List<dynamic> json = jsonDecode(response.body);
    print("==========================");
    print("In between");
    print(json);

    List<WeatherResponse> li = [];
    json.forEach((element) {
      // print(element);
      WeatherResponse weatherResponse = WeatherResponse.fromMap(element);
      li.add(weatherResponse);
    });
    print(li[0].localTimestamp);
    // print(DateTime.now().microsecondsSinceEpoch);
    // print(DateTime.now().millisecondsSinceEpoch)
    return li;
  }

  Future<TideResponse> getTideResponse() async {
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");
    log("Calling Tides API");

    // return TideResponse.fromMap({
    //   "extremes": [
    //     {
    //       "timestamp": 1646227100,
    //       "datetime": "2022-03-02T13:18:20+00:00",
    //       "height": 0.5835172145176015,
    //       "state": "HIGH TIDE"
    //     },
    //     {
    //       "timestamp": 1646250607,
    //       "datetime": "2022-03-02T19:50:07+00:00",
    //       "height": -0.6440050894782114,
    //       "state": "LOW TIDE"
    //     },
    //     {
    //       "timestamp": 1646272358,
    //       "datetime": "2022-03-03T01:52:38+00:00",
    //       "height": 0.4874376243184547,
    //       "state": "HIGH TIDE"
    //     },
    //     {
    //       "timestamp": 1646294363,
    //       "datetime": "2022-03-03T07:59:23+00:00",
    //       "height": -0.5347980659608157,
    //       "state": "LOW TIDE"
    //     },
    //   ],
    // });
    var response = await API.apiHandler(
      url:
          'https://tides.p.rapidapi.com/tides?longitude=11.9416&latitude=79.8083&interval=60&duration=1440',
      requestType: RequestType.Get,
      header: {
        'x-rapidapi-host': 'tides.p.rapidapi.com',
        'x-rapidapi-key': 'ba02214b4emshd031700e9d5d770p18df96jsn30e1ef5a3287'
      },
    );
    final Map<String, dynamic> json = jsonDecode(response);
    print(json);
    TideResponse tideResponse = TideResponse.fromMap(json);
    print(tideResponse);
    return tideResponse;
  }

  Future<WeatherPageModel> getWeatherData(DateTime date) async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("weather")
        .doc("weather")
        .get();
    print(data.data());
    print(data.data().isEmpty);
    if (data.data() != null && data.data().isNotEmpty) {
      //if data exist.
      print("admkasmdkmkds");
      WeatherPageModel weatherPageModel = WeatherPageModel.fromMap(data.data());

      if (DateTime.now().difference(weatherPageModel.timeStamp).inHours >= 12) {
        return await getLatestData(date);
      } else {
        return weatherPageModel;
      }
    } else {
      return await getLatestData(date);
    }
  }

  Future<WeatherPageModel> getLatestData(DateTime date) async {
    List<WeatherResponse> weather = await getWeatherResponse();
    TideResponse tide = await getTideResponse();

    WeatherPageModel weatherPageModel =
        WeatherPageModel.fromResponse(weather, tide, date);
    weatherPageModel.timeStamp = DateTime.now();

    FirebaseFirestore.instance
        .collection("weather")
        .doc("weather")
        .set(weatherPageModel.toMap());

    return weatherPageModel;
  }
}

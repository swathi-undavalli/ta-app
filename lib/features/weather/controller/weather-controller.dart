import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:temple_adventures/features/weather/models/weather_response.dart';
import 'package:http/http.dart' as http;

class WeatherPageLogic {
  WeatherPageController controller = Get.put(WeatherPageController());

  Future<WeatherResponse> getWeatherData() async {
    // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    //magicseaweed.com/api/YOURAPIKEY/forecast/?spot_id=10

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

    try {
      json.forEach((element) {
        print(element);
        WeatherResponse weatherResponse = WeatherResponse.fromMap(element);
        // controller.newList.add(weatherResponse);
        // print(element);
        // print(weatherResponse);
      });
    } catch (e) {
      print(e);
      return null;
    }
    print("controller.newList");
    print(controller.newList);
  }
}

class WeatherPageController extends GetxController {
  List<String> tides = ["Low Tide", "High Tide", "Low Tide"];
  List<String> tideTiming = ["5:41 AM", "11:27 AM", "2:30 PM"];
  List<String> tideHeight = ["0.5 m", "0.96 m", "0.45 m"];
  List<String> windDetails = ["Tide", "Time", "Height"];

  List<dynamic> newList = [];
}

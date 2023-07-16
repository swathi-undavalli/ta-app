import 'package:get/get.dart';
import 'package:temple_adventures/features/weather/models/weatherPage_model.dart';
import 'package:temple_adventures/features/weather/repository/weather_repository.dart';

class WeatherPageLogic {
  WeatherPageController controller = Get.put(WeatherPageController());
  WeatherRepository weatherRepository = WeatherRepository();



  getWeatherData(DateTime date) async {
    controller.showLoading = true;
    controller.weatherPageModel = await weatherRepository.getWeatherData(date);
    controller.showLoading = false;
  }

  onTodayPressed() async {
    getWeatherData(DateTime.now());
  }

  onTomorrowPressed() {
    getWeatherData(DateTime.now().add(Duration(days: 1)));
  }

  onNextDayPressed() {
    getWeatherData(DateTime.now().add(Duration(days: 2)));
  }
}

class WeatherPageController extends GetxController {
  List<String> tideType = [];
  List<String> tideTimingToday = [];
  List<String> tideTimingTom = [];
  List<String> tideHeight = [];
  List<String> windDetails = ["Tide", "Time", "Height"];

  WeatherPageModel? weatherPageModel;

  bool _showLoading = false;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}


import 'package:get/get.dart';

class WeatherPageLogic{
  WeatherPageController controller = Get.put(WeatherPageController());
}


class WeatherPageController extends GetxController{

  List<String> tides = ["Low Tide", "High Tide", "Low Tide"];
  List<String> tideTiming = ["5:41 AM", "11:27 AM", "2:30 PM"];
  List<String> tideHeight = ["0.5 m", "0.96 m", "0.45 m"];

}
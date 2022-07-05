import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/weather/controller/weather-controller.dart';
import 'package:temple_adventures/features/weather/models/tide_response.dart';
import 'package:temple_adventures/features/weather/models/tide_response.dart'
    as tide;
import 'package:intl/intl.dart';

class WeatherPage extends StatelessWidget {
  WeatherPageLogic logic = WeatherPageLogic();
  DateTime now = DateTime.now().add(Duration(days: 2));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: EmployeeAccess(
                access: AccessRights.weatherReport,
                showMessage: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          buildTideTimings(),
                          SizedBox(height: 20),
                          buildTideConditions(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  ///================UI==============///

  Widget buildShowLoading() {
    return GetBuilder<WeatherPageController>(builder: (controller) {
      if (controller.showLoading)
        return Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black54,
            height: Get.height,
            width: Get.width,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          ),
        );
      else
        return SizedBox();
    });
  }

  Widget buildTideConditions(BuildContext context) {
    return GetBuilder<WeatherPageController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 96,
                width: 131,
                decoration: BoxDecoration(
                    color: AppColors.background.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "Temperature",
                      style: TextStyle(
                          color: AppColors.text.black,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w700),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: controller.weatherPageModel.temperature
                                  .toStringAsFixed(1),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff02D2F9),
                                  fontSize: 30)),
                          TextSpan(
                              text:
                                  " °${controller.weatherPageModel.temperatureUnits}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff02D2F9),
                                  fontSize: FontSize.textSize)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 96,
                width: 131,
                decoration: BoxDecoration(
                    color: AppColors.background.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "Wave Height",
                      style: TextStyle(
                          color: AppColors.text.black,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w700),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                (controller.weatherPageModel.waveHeight / 3.28)
                                    .toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff02D2F9),
                              fontSize: 32,
                            ),
                          ),
                          TextSpan(
                              text: " m",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff02D2F9),
                                  fontSize: FontSize.small)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Container(
            height: 215,
            width: 169,
            decoration: BoxDecoration(
                color: AppColors.background.white,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Text(
                  "Wind Speed",
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: FontSize.small,
                      fontWeight: FontWeight.w700),
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: controller.weatherPageModel.windSpeed
                              .toStringAsFixed(1),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff02D2F9),
                              fontSize: 32)),
                      TextSpan(
                          text: " ${controller.weatherPageModel.speedUnits}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff02D2F9),
                              fontSize: FontSize.small)),
                    ],
                  ),
                ),
                Text(
                  "Gusts",
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: FontSize.small,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  controller.weatherPageModel.gusts.toStringAsFixed(1),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff02D2F9),
                      fontSize: 32),
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget buildTideTimings() {
    return GetBuilder<WeatherPageController>(builder: (controller) {
      return Container(
        height: 300,
        width: 315,
        decoration: BoxDecoration(
            color: AppColors.background.white,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 315,
              decoration: BoxDecoration(
                  color: AppColors.background.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Tide Forecast in",
                      style: TextStyle(
                          color: AppColors.text.white,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("Pondicherry",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: AppColors.text.white,
                            fontSize: FontSize.small,
                            fontWeight: FontWeight.w500)),
                    Container(
                      height: 0.5,
                      width: 250,
                      color: AppColors.background.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: controller.windDetails
                            .map((e) => Text(
                                  e,
                                  style: TextStyle(
                                      color: AppColors.text.white,
                                      fontSize: FontSize.small),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 170,
              child: Column(
                children: controller.weatherPageModel.tides
                    .map((tide) => buildTideDetails(tide))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildButtons() {
    // String formattedDate = DateFormat('MMM dd EE').format(now);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppButton.miniFlat(
          text: "Today",
          textColor: AppColors.text.white,
          bgColor: AppColors.background.black,
          onTap: () {
            logic.onTodayPressed();
          },
        ),
        AppButton.miniFlat(
          text: "Tomorrow",
          textColor: AppColors.text.black,
          bgColor: AppColors.background.grey,
          onTap: () {
            logic.onTomorrowPressed();
          },
        ),
      ],
    );
  }

  Widget buildTideDetails(Extreme tide) {
    getColor() {
      if (tide.height >= 0.5) {
        return AppColors.text.green;
      } else if (tide.height >= 0.2) {
        return Colors.yellow;
      } else {
        return AppColors.text.red.withOpacity(0.8);
      }
    }

    DateTime time = tide.datetime.add(Duration(hours: 5, minutes: 30));
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              getTideType(tide.state),
              style: TextStyle(
                  color: AppColors.text.skyBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Text(
                  DateFormat('hh:mm a').format(time) ?? "-",
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  getDay(tide.datetime),
                  style: TextStyle(
                      color: AppColors.text.black.withOpacity(0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              "${tide.height > 0 ? "  " : ""}${tide.height.toStringAsFixed(2)} m" ??
                  "-",
              style: TextStyle(
                  color: getColor(), fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  getDay(DateTime date) {
    if (DateTime.now().day == date.day) {
      return "Today";
    } else if (date.day == DateTime.now().add(Duration(days: 1)).day) {
      return "Tomorrow";
    } else {
      return "Yesterday";
    }
  }

  getTideType(tide.State state) {
    if (state == tide.State.HIGH_TIDE) {
      return "High";
    } else if (state == tide.State.LOW_TIDE) {
      return "Low";
    } else {
      return "-";
    }
  }
}

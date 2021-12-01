import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/weather/controller/weather-controller.dart';

class WeatherPage extends StatefulWidget {
  WeatherPageLogic logic = WeatherPageLogic();

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Position pos = Position();
  List<String> windDetails = ["Tide", "Time", "Height"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      SizedBox(height: 30),
                      buildTideTimings(),
                      SizedBox(height: 20),
                      buildTideConditions(context),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///================UI==============///

  Widget buildTideConditions(BuildContext context) {
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
                      children: const <TextSpan>[
                        TextSpan(
                            text: '18',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff02D2F9),
                                fontSize: FontSize.title)),
                        TextSpan(
                            text: '  kmph',
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
                      children: const <TextSpan>[
                        TextSpan(
                            text: '1.8',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff02D2F9),
                                fontSize: FontSize.title)),
                        TextSpan(
                            text: '  mt',
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
                "Weather",
                style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: FontSize.small,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "36",
                style: TextStyle(
                    color: AppColors.text.skyBlue,
                    fontSize: FontSize.title,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Mostly Windy",
                style: TextStyle(
                    color: AppColors.text.darkgrey,
                    fontSize: FontSize.small,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Precipitation: 8% ",
                style: TextStyle(
                    color: AppColors.text.darkgrey,
                    fontSize: FontSize.small,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Humidity: 58%",
                style: TextStyle(
                    color: AppColors.text.darkgrey,
                    fontSize: FontSize.small,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTideTimings() {
    return GetBuilder<WeatherPageController>(builder: (controller) {
      return Container(
        height: 255,
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
                    left: 15, right: 15, top: 15, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's tide times for Pondicherry: \n   Monday 27 September 2021",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.text.white,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 0.5,
                      width: 250,
                      color: AppColors.background.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: windDetails
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
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...controller.tides.map((e) => Text(
                            e,
                            style: TextStyle(
                                color: AppColors.text.skyBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...controller.tideTiming
                          .map((e) => Text(
                                e,
                                style: TextStyle(
                                    color: AppColors.text.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ))
                          .toList(),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...controller.tideHeight
                          .map((e) => Text(
                                e,
                                style: TextStyle(
                                    color: AppColors.text.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ))
                          .toList(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppButton.miniFlat(
          text: "Today",
          textColor: AppColors.text.white,
          bgColor: AppColors.background.black,
        ),
        AppButton.miniFlat(
          text: "Tomorrow",
          textColor: AppColors.text.black,
          bgColor: AppColors.background.grey,
        ),
        AppButton.miniFlat(
          text: "Nov 2, Tue",
          textColor: AppColors.text.black,
          bgColor: AppColors.background.grey,
        ),
      ],
    );
  }
}

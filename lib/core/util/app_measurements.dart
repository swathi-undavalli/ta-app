import 'package:flutter/material.dart';

class AppMeasures {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double statusBarHeight = 0;

  static init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    statusBarHeight = MediaQuery.of(context).viewPadding.top;
  }

  static double commentWidth = AppMeasures.screenWidth - 16 - 38 - 24 - 22;
  static double postContainerHeight = AppMeasures.screenWidth * 4 / 3;
  static double pageMargin = 22;

  static double smallDevicePoint = 708;

  static bool get isSmallDevice => AppMeasures.screenHeight < smallDevicePoint;
  static bool get scaffoldHeight => AppMeasures.screenHeight < smallDevicePoint;
}

